import argparse
import datetime
import fcntl
import json
import os
import pathlib
import re
import signal
import subprocess
import sys
import time


STATE_DIRECTORY = pathlib.Path("/var/lib/net-usage")
UNITS = {"B": 1}
UNITS.update({f"{prefix}B": 1000**power for power, prefix in enumerate("KMGTPE", 1)})
UNITS.update({f"{prefix}iB": 1024**power for power, prefix in enumerate("KMGTPE", 1)})


def collect():
    STATE_DIRECTORY.mkdir(mode=0o755, parents=True, exist_ok=True)
    with (STATE_DIRECTORY / "lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        today = datetime.date.today().isoformat()
        daily_file = STATE_DIRECTORY / today
        received, transmitted = 0, 0
        if daily_file.exists():
            _, received, transmitted = daily_file.read_text().split()
            received, transmitted = int(received), int(transmitted)
        # Atomic list-and-reset: packets arriving during collection stay counted.
        result = subprocess.check_output(
            ["nft", "-j", "reset", "counters", "ip", "net_usage"], text=True
        )
        counters = {
            entry["counter"]["name"]: entry["counter"]["bytes"]
            for entry in json.loads(result)["nftables"]
            if "counter" in entry
        }
        received += counters["internet_rx"]
        transmitted += counters["internet_tx"]
        temporary_file = daily_file.with_suffix(".tmp")
        with temporary_file.open("w") as output:
            output.write(f"{today} {received} {transmitted}\n")
            output.flush()
            os.fsync(output.fileno())
        temporary_file.replace(daily_file)


def programs_file(day):
    return STATE_DIRECTORY / f"{day}.programs"


def read_programs(day):
    """Return {(program, cgroup): [rx, tx]} for one day."""
    usage = {}
    file = programs_file(day)
    if file.exists():
        for line in file.read_text().splitlines():
            program, cgroup, received, transmitted = line.split("\t")
            usage[(program, cgroup)] = [int(received), int(transmitted)]
    return usage


def add_programs(deltas):
    """Merge {(program, cgroup): (rx, tx)} byte deltas into today's file."""
    STATE_DIRECTORY.mkdir(mode=0o755, parents=True, exist_ok=True)
    with (STATE_DIRECTORY / "lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        today = datetime.date.today().isoformat()
        usage = read_programs(today)
        for key, (received, transmitted) in deltas.items():
            total = usage.setdefault(key, [0, 0])
            total[0] += received
            total[1] += transmitted
        temporary_file = programs_file(today).with_suffix(".tmp")
        with temporary_file.open("w") as output:
            for (program, cgroup), (received, transmitted) in sorted(usage.items()):
                output.write(f"{program}\t{cgroup}\t{received}\t{transmitted}\n")
            output.flush()
            os.fsync(output.fileno())
        temporary_file.replace(programs_file(today))


def cgroup_paths():
    """Map cgroup id (= cgroupfs inode) to path."""
    root = pathlib.Path("/sys/fs/cgroup")
    paths = {root.stat().st_ino: "/"}
    pending = [root]
    while pending:
        with os.scandir(pending.pop()) as entries:
            for entry in entries:
                if entry.is_dir(follow_symlinks=False):
                    paths[entry.stat(follow_symlinks=False).st_ino] = entry.path.removeprefix(str(root))
                    pending.append(entry.path)
    return paths


def program_name(comm):
    # Nix wrappers show up as ".claude-wrapped" / ".zen-beta-wrapp" (comm is 15 chars).
    return re.sub(r"^\.(.+?)-wra\w*$", r"\1", comm).translate({9: " ", 10: " "})


def track_programs():
    """Run the eBPF counter; every snapshot is cumulative, save only the delta."""
    script = os.environ["NET_USAGE_PROGRAMS_SCRIPT"]
    environment = {**os.environ, "BPFTRACE_MAP_KEYS_MAX": "65536"}
    tracer = subprocess.Popen(
        ["bpftrace", "-f", "json", script], stdout=subprocess.PIPE, text=True, env=environment
    )
    # On stop bpftrace prints a final snapshot; keep reading until it exits.
    for stop_signal in (signal.SIGTERM, signal.SIGINT):
        signal.signal(stop_signal, lambda *_: tracer.terminate())
    previous = {}
    names = {}
    for line in tracer.stdout:
        message = json.loads(line)
        if message["type"] != "map":
            continue
        current = {
            (direction, *key.rsplit(",", 1)): value
            for direction, entries in message["data"].items()
            for key, value in entries.items()
        }
        deltas = {}
        for (direction, comm, cgroup_id), value in current.items():
            delta = value - previous.get((direction, comm, cgroup_id), 0)
            if delta <= 0:
                continue
            if cgroup_id not in names:
                names.update({str(cgroup): path for cgroup, path in cgroup_paths().items()})
                names.setdefault(cgroup_id, "?")
            totals = deltas.setdefault((program_name(comm), names[cgroup_id]), [0, 0])
            totals[0 if direction == "@rx" else 1] += delta
        previous.update(current)
        if deltas:
            add_programs(deltas)
    if tracer.wait() not in (0, -signal.SIGTERM, -signal.SIGINT):
        sys.exit(tracer.returncode)


def print_markdown_table(headers, rows):
    widths = [max(len(cell) for cell in column) for column in zip(headers, *rows)]
    print("| " + " | ".join(header.ljust(width) for header, width in zip(headers, widths)) + " |")
    print("| " + " | ".join(
        ":" + "-" * (width - 1) if index == 0 else "-" * (width - 1) + ":"
        for index, width in enumerate(widths)
    ) + " |")
    for row in rows:
        print("| " + " | ".join(
            cell.ljust(width) if index == 0 else cell.rjust(width)
            for index, (cell, width) in enumerate(zip(row, widths))
        ) + " |")


def report(days, json_output=False, unit="MB", watch=False):
    today = datetime.date.today()
    first_day = today - datetime.timedelta(days=days - 1)
    interface_usage = {}
    for interface in ("enp6s0", "tailscale0"):
        result = subprocess.check_output(
            ["vnstat", "-i", interface, "--json", "d", "0"], text=True
        )
        interface_usage[interface] = {
            datetime.date(**entry["date"]): (entry["rx"], entry["tx"])
            for entry in json.loads(result)["interfaces"][0]["traffic"]["day"]
        }
    sources = ("internet", "enp6s0", "tailscale0")
    totals = {source: {"rx_bytes": 0, "tx_bytes": 0} for source in sources}
    rows = []
    for offset in range(days):
        day = first_day + datetime.timedelta(days=offset)
        daily_file = STATE_DIRECTORY / day.isoformat()
        received, transmitted = 0, 0
        if daily_file.exists():
            _, received, transmitted = daily_file.read_text().split()
        row = {
            "date": day.isoformat(),
            "internet": {"rx_bytes": int(received), "tx_bytes": int(transmitted)},
        }
        for interface in ("enp6s0", "tailscale0"):
            received, transmitted = interface_usage[interface].get(day, (0, 0))
            row[interface] = {"rx_bytes": received, "tx_bytes": transmitted}
        for source in sources:
            for direction in ("rx_bytes", "tx_bytes"):
                totals[source][direction] += row[source][direction]
        rows.append(row)

    if json_output:
        print(json.dumps({"days": rows, "totals": totals}, indent=None if watch else 2))
        return

    print(f"{unit} = {UNITS[unit]:,} bytes. RX = download; TX = upload.")
    if watch:
        print(f"Updated: {datetime.datetime.now().astimezone().isoformat(timespec='seconds')}")
    print("Internet saved every 5 min; vnstat interface totals include local traffic.\n")
    headers = ["Date"] + [
        f"{source} {direction} ({unit})"
        for source in ("Internet", "enp6s0", "tailscale0")
        for direction in ("RX", "TX")
    ]
    table_rows = []
    for row in [*rows, {"date": "TOTAL", **totals}]:
        values = [
            f"{row[source][direction]:,}" if unit == "B" else f"{row[source][direction] / UNITS[unit]:,.2f}"
            for source in sources
            for direction in ("rx_bytes", "tx_bytes")
        ]
        table_rows.append([row["date"], *values])
    print_markdown_table(headers, table_rows)


def report_programs(days, json_output=False, unit="MB", top=None, watch=False):
    today = datetime.date.today()
    programs = {}
    for offset in range(days):
        for (program, cgroup), (received, transmitted) in read_programs(
            today - datetime.timedelta(days=offset)
        ).items():
            units = programs.setdefault(program, {})
            total = units.setdefault(cgroup, [0, 0])
            total[0] += received
            total[1] += transmitted
    rows = sorted(
        (
            {
                "program": program,
                "rx_bytes": sum(rx for rx, _ in units.values()),
                "tx_bytes": sum(tx for _, tx in units.values()),
                "cgroups": [
                    {"cgroup": cgroup, "rx_bytes": rx, "tx_bytes": tx}
                    for cgroup, (rx, tx) in sorted(units.items(), key=lambda item: -item[1][1])
                ],
            }
            for program, units in programs.items()
        ),
        key=lambda row: (-row["tx_bytes"], -row["rx_bytes"], row["program"]),
    )
    totals = {
        "rx_bytes": sum(row["rx_bytes"] for row in rows),
        "tx_bytes": sum(row["tx_bytes"] for row in rows),
    }
    shown = rows[:top]

    if json_output:
        print(json.dumps({"days": days, "programs": shown, "totals": totals}, indent=None if watch else 2))
        return

    print(f"{unit} = {UNITS[unit]:,} bytes. RX = download; TX = upload. Last {days} day(s), internet only, by program.")
    if watch:
        print(f"Updated: {datetime.datetime.now().astimezone().isoformat(timespec='seconds')}")
    print("Payload bytes (TCP/UDP IPv4) saved every minute; Unit = busiest cgroup of the program.\n")

    def format_bytes(value):
        return f"{value:,}" if unit == "B" else f"{value / UNITS[unit]:,.2f}"

    table_rows = []
    for row in shown:
        unit_name = row["cgroups"][0]["cgroup"].rsplit("/", 1)[-1] or "/"
        if len(row["cgroups"]) > 1:
            unit_name += f" (+{len(row['cgroups']) - 1})"
        table_rows.append([row["program"], unit_name, format_bytes(row["rx_bytes"]), format_bytes(row["tx_bytes"])])
    label = "TOTAL" if len(shown) == len(rows) else f"TOTAL (all {len(rows)}, top {len(shown)} shown)"
    table_rows.append([label, "", format_bytes(totals["rx_bytes"]), format_bytes(totals["tx_bytes"])])
    print_markdown_table(["Program", "Unit", f"RX ({unit})", f"TX ({unit})"], table_rows)


def parse_watch_interval(value):
    match = re.fullmatch(r"(\d+(?:\.\d+)?)([smh]?)", value)
    if not match:
        raise argparse.ArgumentTypeError("interval must be a positive number with optional s, m or h suffix")
    seconds = float(match[1]) * {"": 1, "s": 1, "m": 60, "h": 3600}[match[2]]
    if seconds <= 0 or not seconds < float("inf"):
        raise argparse.ArgumentTypeError("interval must be positive and finite")
    return seconds


if __name__ == "__main__":
    if sys.argv[1:] == ["--collect"]:
        collect()
    elif sys.argv[1:] == ["--track-programs"]:
        track_programs()
    else:
        parser = argparse.ArgumentParser(prog="net-usage", description="Daily internet and vnstat traffic usage.")
        parser.add_argument("days", nargs="?", type=int, default=15, help="days including today (default: 15)")
        parser.add_argument("--json", action="store_true", help="output JSON with exact byte counts")
        parser.add_argument("--by-program", action="store_true", help="internet usage per program, sorted by TX")
        parser.add_argument("--top", type=int, metavar="N", help="with --by-program: only the N biggest uploaders (default: 20 in table, all in JSON)")
        parser.add_argument("--unit", choices=UNITS, default="MB", help="table unit (default: MB); JSON always uses exact bytes")
        parser.add_argument("--watch", nargs="?", const=5.0, type=parse_watch_interval,
                            metavar="INTERVAL", help="refresh until Ctrl-C (default: 5s); supports s/m/h; JSON emits one object per line")
        arguments = parser.parse_args()
        if arguments.days <= 0:
            parser.error("days must be a positive integer")
        if arguments.top is not None and (not arguments.by_program or arguments.top <= 0):
            parser.error("--top needs --by-program and a positive integer")
        try:
            while True:
                if arguments.watch is not None and not arguments.json and sys.stdout.isatty():
                    print("\033[2J\033[H", end="")
                if arguments.by_program:
                    top = arguments.top if arguments.top or arguments.json else 20
                    report_programs(arguments.days, arguments.json, arguments.unit, top, arguments.watch is not None)
                else:
                    report(arguments.days, arguments.json, arguments.unit, arguments.watch is not None)
                sys.stdout.flush()
                if arguments.watch is None:
                    break
                time.sleep(arguments.watch)
        except KeyboardInterrupt:
            pass
