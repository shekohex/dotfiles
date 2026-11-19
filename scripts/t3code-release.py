#!/usr/bin/env python3
"""Print or update T3 Code release pins (latest nightly by default)."""

import argparse
import base64
import json
import re
import subprocess
import sys
from pathlib import Path
from tempfile import NamedTemporaryFile


def github_json(endpoint):
    return json.loads(
        subprocess.check_output(
            ["gh", "api", f"repos/pingdotgg/t3code/{endpoint}"], text=True
        )
    )


def find_release(tag):
    if tag:
        return github_json(f"releases/tags/v{tag.removeprefix('v')}")
    page = 1
    while releases := github_json(f"releases?per_page=100&page={page}"):
        for release in releases:
            if not release["draft"] and "-nightly." in release["tag_name"]:
                return release
        page += 1
    sys.exit("No nightly release found")


def asset_hash(assets, filename):
    if filename not in assets:
        sys.exit(f"Missing release asset: {filename}")
    digest = assets[filename].get("digest") or ""
    if not re.fullmatch(r"sha256:[0-9a-fA-F]{64}", digest):
        sys.exit(f"Missing or invalid SHA-256 digest for {filename}")
    digest_bytes = bytes.fromhex(digest.removeprefix("sha256:"))
    return "sha256-" + base64.b64encode(digest_bytes).decode()


def update_pins(assignments):
    module = Path("modules/programs/t3code.nix")
    if not module.is_file():
        sys.exit("Run the updater from the dotfiles repo root")
    original = updated = module.read_text()
    for attribute, assignment in assignments.items():
        updated, count = re.subn(
            rf'^  {attribute} = "[^"\n]*";$', assignment, updated, flags=re.M
        )
        if count != 1:
            sys.exit(f"Expected one {attribute} assignment in {module}, found {count}")

    if updated == original:
        return False

    output = NamedTemporaryFile(mode="w", dir=module.parent, delete=False)
    temporary = Path(output.name)
    try:
        with output:
            output.write(updated)
        temporary.chmod(module.stat().st_mode & 0o777)
        temporary.replace(module)
    finally:
        temporary.unlink(missing_ok=True)
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("tag", nargs="?", help="release tag (default: latest nightly)")
    parser.add_argument(
        "--update", action="store_true", help="write pins to the local Nix module"
    )
    args = parser.parse_args()

    release = find_release(args.tag)
    version = release["tag_name"].removeprefix("v")
    if not re.fullmatch(r"[a-zA-Z0-9][a-zA-Z0-9.+-]*", version):
        sys.exit(f"Invalid release version: {version}")
    assets = {asset["name"]: asset for asset in release["assets"]}
    desktop_asset = f"T3-Code-{version}-x86_64.AppImage"
    if desktop_asset not in assets and "-nightly." in version:
        desktop_asset = "T3-Code-Nightly-x86_64.AppImage"

    pins = {
        "version": version,
        "desktopAsset": desktop_asset,
        "desktopHash": asset_hash(assets, desktop_asset),
        "cliHash": asset_hash(assets, f"t3-{version}-linux-x64.tar.gz"),
    }
    assignments = {name: f'  {name} = "{value}";' for name, value in pins.items()}
    if args.update:
        status = "Updated pins to" if update_pins(assignments) else "Already pinned to"
        print(f"{status} {version}")
    else:
        print("\n".join(assignments.values()))


if __name__ == "__main__":
    main()
