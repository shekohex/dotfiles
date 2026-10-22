import subprocess

from gi.repository import GObject, Nautilus

MEDIA_TYPES = ("video/", "audio/", "image/")


class MediaConvertExtension(GObject.GObject, Nautilus.MenuProvider):
    def get_file_items(self, files):
        if not files or not all(f.get_mime_type().startswith(MEDIA_TYPES) and f.get_uri_scheme() == "file" for f in files):
            return []
        item = Nautilus.MenuItem(
            name="MediaConvert::convert",
            label="Convert / Compress…",
            tip="Convert to another format or shrink size with ffmpeg",
        )
        item.connect("activate", self.on_activate, files)
        return [item]

    def on_activate(self, _item, files):
        paths = [f.get_location().get_path() for f in files]
        subprocess.Popen(["@mediaConvert@", *paths])
