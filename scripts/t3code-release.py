#!/usr/bin/env python3
"""Print Nix version/hash assignments for a T3 Code release (latest nightly by default)."""

import base64
import json
import sys
import urllib.request


def github_json(endpoint):
    request = urllib.request.Request(
        f"https://api.github.com/repos/pingdotgg/t3code/{endpoint}",
        headers={"Accept": "application/vnd.github+json", "User-Agent": "t3code-release"},
    )
    with urllib.request.urlopen(request) as response:
        return json.load(response)


def find_release():
    if len(sys.argv) > 1:
        return github_json(f"releases/tags/v{sys.argv[1].removeprefix('v')}")
    page = 1
    while releases := github_json(f"releases?per_page=100&page={page}"):
        for release in releases:
            if not release["draft"] and "-nightly." in release["tag_name"]:
                return release
        page += 1
    sys.exit("No nightly release found")


release = find_release()
version = release["tag_name"].removeprefix("v")
assignments = {"version": version}
for attribute, filename in {
    "desktopHash": f"T3-Code-{version}-x86_64.AppImage",
    "cliHash": f"t3-{version}-linux-x64.tar.gz",
}.items():
    asset = next((asset for asset in release["assets"] if asset["name"] == filename), None)
    if asset is None or not (asset.get("digest") or "").startswith("sha256:"):
        sys.exit(f"Missing SHA-256 digest for {filename}")
    digest = bytes.fromhex(asset["digest"].removeprefix("sha256:"))
    assignments[attribute] = "sha256-" + base64.b64encode(digest).decode()

for attribute, value in assignments.items():
    print(f'  {attribute} = "{value}";')
