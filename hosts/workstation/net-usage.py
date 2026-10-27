import datetime
import fcntl
import json
import os
import pathlib
import subprocess
import sys


STATE_DIRECTORY = pathlib.Path("/var/lib/net-usage")


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


def report(days):
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
    print("MiB; internet saved every 5 min; vnstat includes local traffic.")
    print(f"{'Date':<10}  {'Internet RX':>12} {'TX':>12}  "
          f"{'enp6s0 RX':>12} {'TX':>12}  {'tailscale0 RX':>13} {'TX':>12}")
    totals = [0] * 6
    for offset in range(days):
        day = first_day + datetime.timedelta(days=offset)
        daily_file = STATE_DIRECTORY / day.isoformat()
        received, transmitted = 0, 0
        if daily_file.exists():
            _, received, transmitted = daily_file.read_text().split()
        values = [int(received), int(transmitted)]
        for interface in ("enp6s0", "tailscale0"):
            values.extend(interface_usage[interface].get(day, (0, 0)))
        totals = [total + value for total, value in zip(totals, values)]
        print(f"{day.isoformat():<10} " + " ".join(f"{value / 1048576:12.2f}" for value in values))
    print(f"{'TOTAL':<10} " + " ".join(f"{value / 1048576:12.2f}" for value in totals))


if __name__ == "__main__":
    if sys.argv[1:] == ["--collect"]:
        collect()
    elif len(sys.argv) <= 2 and (len(sys.argv) == 1 or sys.argv[1].isdigit() and int(sys.argv[1]) > 0):
        report(int(sys.argv[1]) if len(sys.argv) == 2 else 15)
    else:
        sys.exit("Usage: net-usage [days] (positive integer; default 15)")
