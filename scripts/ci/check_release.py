"""Fail before exposing signing secrets when release metadata is inconsistent."""
import os
from pathlib import Path
import re
import subprocess
import sys

VERSION = re.compile(r"[0-9]+\.[0-9]+\.[0-9]+\+([1-9][0-9]*)")


def validate(pubspec, tag, previous_tags):
    match = re.search(r"^version:\s*(\S+)\s*$", pubspec, re.MULTILINE)
    version = match.group(1) if match else ""
    parsed = VERSION.fullmatch(version)
    if not parsed or int(parsed.group(1)) > 2100000000:
        raise ValueError("Expected pubspec version X.Y.Z+BUILD with a valid Android build number")
    if tag != f"v{version}":
        raise ValueError("The tag must be exactly v followed by the pubspec version, including +BUILD")
    build = int(parsed.group(1))
    for previous in previous_tags:
        if previous == tag:
            continue
        old = VERSION.fullmatch(previous.removeprefix("v")) if previous.startswith("v") else None
        if old and int(old.group(1)) >= build:
            raise ValueError("The build number must exceed all existing version tags")
    return version


def main():
    tags = subprocess.check_output(["git", "tag", "--list", "v*"], text=True).splitlines()
    try:
        version = validate(Path("pubspec.yaml").read_text(), os.environ.get("GITHUB_REF_NAME", ""), tags)
    except ValueError as error:
        print(f"Release rejected: {error}", file=sys.stderr)
        return 1
    with open(os.environ["GITHUB_OUTPUT"], "a") as output:
        output.write(f"version={version}\n")
    print(f"Release validated: {version}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
