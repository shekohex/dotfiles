#!@python@/bin/python3
"""GTK4 front-end for ffmpeg: convert / compress media files. Usage: media-convert FILE..."""
import subprocess
import sys
import threading
from pathlib import Path

import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Adw, Gio, GLib, Gtk

QUALITIES = ["Small file", "Balanced", "High quality"]
RESOLUTIONS = [("Original", None), ("1080p", 1080), ("720p", 720), ("480p", 480), ("360p", 360)]

# label -> (extension, ffmpeg args per quality index 0..2)
VIDEO_FORMATS = {
    "MP4 (H.264)": ("mp4", lambda q: ["-c:v", "libx264", "-preset", "medium", "-crf", str((28, 23, 19)[q]), "-c:a", "aac", "-b:a", "128k", "-movflags", "+faststart"]),
    "MP4 (H.265, smaller)": ("mp4", lambda q: ["-c:v", "libx265", "-preset", "medium", "-crf", str((32, 27, 23)[q]), "-tag:v", "hvc1", "-c:a", "aac", "-b:a", "128k", "-movflags", "+faststart"]),
    "WebM (VP9)": ("webm", lambda q: ["-c:v", "libvpx-vp9", "-b:v", "0", "-crf", str((38, 32, 26)[q]), "-row-mt", "1", "-c:a", "libopus", "-b:a", "96k"]),
    "MKV (H.264)": ("mkv", lambda q: ["-c:v", "libx264", "-preset", "medium", "-crf", str((28, 23, 19)[q]), "-c:a", "aac", "-b:a", "128k"]),
    "GIF (animated)": ("gif", lambda q: ["-an", "-vf", "fps=%d,scale=%d:-1:flags=lanczos,split[a][b];[a]palettegen[p];[b][p]paletteuse" % ((8, 12, 15)[q], (320, 480, 640)[q])]),
}
AUDIO_FORMATS = {
    "MP3": ("mp3", lambda q: ["-c:a", "libmp3lame", "-q:a", str((6, 4, 2)[q])]),
    "Opus": ("opus", lambda q: ["-c:a", "libopus", "-b:a", ("64k", "96k", "160k")[q]]),
    "AAC (M4A)": ("m4a", lambda q: ["-c:a", "aac", "-b:a", ("96k", "128k", "192k")[q]]),
    "OGG (Vorbis)": ("ogg", lambda q: ["-c:a", "libvorbis", "-q:a", str((3, 5, 7)[q])]),
    "FLAC (lossless)": ("flac", lambda q: ["-c:a", "flac"]),
    "WAV": ("wav", lambda q: ["-c:a", "pcm_s16le"]),
}
IMAGE_FORMATS = {
    "WebP": ("webp", lambda q: ["-c:v", "libwebp", "-quality", str((60, 80, 92)[q])]),
    "JPEG": ("jpg", lambda q: ["-q:v", str((8, 4, 2)[q])]),
    "PNG": ("png", lambda q: ["-c:v", "png"]),
    "AVIF": ("avif", lambda q: ["-c:v", "libaom-av1", "-still-picture", "1", "-crf", str((42, 32, 22)[q]), "-cpu-used", "6"]),
}


def media_kind(path):
    content_type = Gio.content_type_guess(str(path), None)[0] or ""
    top = content_type.split("/")[0]
    return top if top in ("video", "audio", "image") else None


def formats_for(kind):
    if kind == "video":
        return {**VIDEO_FORMATS, **{f"{k} (audio only)": v for k, v in AUDIO_FORMATS.items()}}
    return {"audio": AUDIO_FORMATS, "image": IMAGE_FORMATS}[kind]


def unique_output(source, ext):
    candidate = source.with_name(f"{source.stem}_converted.{ext}")
    counter = 2
    while candidate.exists():
        candidate = source.with_name(f"{source.stem}_converted_{counter}.{ext}")
        counter += 1
    return candidate


def probe_duration(path):
    result = subprocess.run(
        ["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", str(path)],
        capture_output=True, text=True,
    )
    try:
        return float(result.stdout.strip())
    except ValueError:
        return 0.0


def human_size(num_bytes):
    for unit in ("B", "KB", "MB", "GB"):
        if num_bytes < 1024 or unit == "GB":
            return f"{num_bytes:.1f} {unit}" if unit != "B" else f"{num_bytes} B"
        num_bytes /= 1024


class ConvertWindow(Adw.ApplicationWindow):
    def __init__(self, app, files, kind):
        super().__init__(application=app, title="Convert Media", default_width=460)
        self.files = files
        self.kind = kind
        self.formats = formats_for(kind)
        self.process = None
        self.cancelled = False

        self.format_row = Adw.ComboRow(title="Convert to", model=Gtk.StringList.new(list(self.formats)))
        self.quality_row = Adw.ComboRow(title="Quality", model=Gtk.StringList.new(QUALITIES), selected=1)
        self.resolution_row = Adw.ComboRow(title="Max height", model=Gtk.StringList.new([r[0] for r in RESOLUTIONS]))
        self.resolution_row.set_visible(kind != "audio")
        self.format_row.connect("notify::selected", self.on_format_changed)

        group = Adw.PreferencesGroup(title=self.describe_selection())
        for row in (self.format_row, self.quality_row, self.resolution_row):
            group.add(row)
        self.convert_button = Gtk.Button(label="Convert", halign=Gtk.Align.CENTER, css_classes=["suggested-action", "pill"])
        self.convert_button.connect("clicked", self.on_convert)
        form = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=18, margin_top=12, margin_bottom=24, margin_start=18, margin_end=18)
        form.append(group)
        form.append(self.convert_button)

        self.status_label = Gtk.Label(wrap=True, xalign=0)
        self.progress_bar = Gtk.ProgressBar()
        self.cancel_button = Gtk.Button(label="Cancel", halign=Gtk.Align.CENTER, css_classes=["pill"])
        self.cancel_button.connect("clicked", self.on_cancel)
        progress = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12, margin_top=24, margin_bottom=24, margin_start=18, margin_end=18)
        for widget in (self.status_label, self.progress_bar, self.cancel_button):
            progress.append(widget)

        self.stack = Gtk.Stack()
        self.stack.add_named(form, "form")
        self.stack.add_named(progress, "progress")

        toolbar = Adw.ToolbarView(content=self.stack)
        toolbar.add_top_bar(Adw.HeaderBar())
        self.set_content(toolbar)
        self.on_format_changed()

    def describe_selection(self):
        if len(self.files) == 1:
            return self.files[0].name
        return f"{len(self.files)} files"

    def selected_format(self):
        return list(self.formats.values())[self.format_row.get_selected()]

    def on_format_changed(self, *_):
        ext, _builder = self.selected_format()
        lossless = ext in ("flac", "wav", "png")
        self.quality_row.set_sensitive(not lossless)
        self.resolution_row.set_sensitive(ext not in ("gif",) and not self.is_audio_only(ext))

    def is_audio_only(self, ext):
        return self.kind == "audio" or ext in {v[0] for v in AUDIO_FORMATS.values()}

    def on_convert(self, _button):
        self.ext, builder = self.selected_format()
        self.codec_args = builder(self.quality_row.get_selected())
        self.max_height = RESOLUTIONS[self.resolution_row.get_selected()][1]
        self.stack.set_visible_child_name("progress")
        threading.Thread(target=self.run_all, daemon=True).start()

    def on_cancel(self, _button):
        self.cancelled = True
        if self.process:
            self.process.terminate()

    def ui(self, func, *args):
        GLib.idle_add(lambda: func(*args) and False)

    def set_status(self, text, fraction=None):
        self.status_label.set_text(text)
        if fraction is not None:
            self.progress_bar.set_fraction(fraction)

    def build_command(self, source, output):
        command = ["ffmpeg", "-hide_banner", "-nostdin", "-n", "-i", str(source)]
        if self.is_audio_only(self.ext):
            command.append("-vn")
        elif self.max_height and self.ext != "gif":
            command += ["-vf", f"scale=-2:'min(ih,{self.max_height})'"]
        command += self.codec_args + ["-progress", "pipe:1", "-nostats", str(output)]
        return command

    def run_all(self):
        total_before = total_after = 0
        failures = []
        for index, source in enumerate(self.files, start=1):
            if self.cancelled:
                break
            output = unique_output(source, self.ext)
            label = f"({index}/{len(self.files)}) {source.name}"
            self.ui(self.set_status, label, 0.0)
            duration = probe_duration(source)
            self.process = subprocess.Popen(
                self.build_command(source, output),
                stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
            )
            stderr_chunks = []
            threading.Thread(target=lambda: stderr_chunks.append(self.process.stderr.read()), daemon=True).start()
            for line in self.process.stdout:
                if line.startswith("out_time_us=") and duration:
                    try:
                        seconds = int(line.split("=")[1]) / 1_000_000
                    except ValueError:
                        continue
                    self.ui(self.set_status, label, min(seconds / duration, 1.0))
            if self.process.wait() == 0:
                total_before += source.stat().st_size
                total_after += output.stat().st_size
            else:
                output.unlink(missing_ok=True)
                if not self.cancelled:
                    failures.append(f"{source.name}: {''.join(stderr_chunks).strip().splitlines()[-1:]}")
        self.ui(self.show_result, total_before, total_after, failures)

    def show_result(self, before, after, failures):
        if self.cancelled:
            message = "Cancelled."
        elif failures:
            message = "Failed:\n" + "\n".join(failures)
        else:
            saved = f" ({(after - before) / before:+.0%})" if before else ""
            message = f"Done. {human_size(before)} → {human_size(after)}{saved}"
        self.set_status(message, 1.0 if not failures else 0.0)
        self.cancel_button.set_label("Close")
        self.cancel_button.disconnect_by_func(self.on_cancel)
        self.cancel_button.connect("clicked", lambda _b: self.close())


class MediaConvertApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id="me.shadykhalifa.MediaConvert", flags=Gio.ApplicationFlags.NON_UNIQUE)
        self.paths = [Path(arg) for arg in sys.argv[1:]]

    def do_activate(self):
        kinds = {path: media_kind(path) for path in self.paths}
        first_kind = next((k for k in kinds.values() if k), None)
        files = [path for path, kind in kinds.items() if kind == first_kind]
        if not first_kind:
            print("No supported media files given", file=sys.stderr)
            self.quit()
            return
        ConvertWindow(self, files, first_kind).present()


if __name__ == "__main__":
    app = MediaConvertApp()
    sys.exit(app.run([sys.argv[0]]))
