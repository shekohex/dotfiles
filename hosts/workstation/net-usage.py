import argparse
import datetime
import fcntl
import json
import os
import pathlib
import re
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
    else:
        parser = argparse.ArgumentParser(prog="net-usage", description="Daily internet and vnstat traffic usage.")
        parser.add_argument("days", nargs="?", type=int, default=15, help="days including today (default: 15)")
        parser.add_argument("--json", action="store_true", help="output JSON with exact byte counts")
        parser.add_argument("--unit", choices=UNITS, default="MB", help="table unit (default: MB); JSON always uses exact bytes")
        parser.add_argument("--watch", nargs="?", const=5.0, type=parse_watch_interval,
                            metavar="INTERVAL", help="refresh until Ctrl-C (default: 5s); supports s/m/h; JSON emits one object per line")
        arguments = parser.parse_args()
        if arguments.days <= 0:
            parser.error("days must be a positive integer")
        try:
            while True:
                if arguments.watch is not None and not arguments.json and sys.stdout.isatty():
                    print("\033[2J\033[H", end="")
                report(arguments.days, arguments.json, arguments.unit, arguments.watch is not None)
                sys.stdout.flush()
                if arguments.watch is None:
                    break
                time.sleep(arguments.watch)
        except KeyboardInterrupt:
            pass
