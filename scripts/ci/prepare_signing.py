"""Decode the existing upload key without printing secret values."""
import base64
import os
from pathlib import Path
import sys


def main():
    required = ["ANDROID_KEYSTORE_BASE64", "ANDROID_KEYSTORE_PASSWORD",
                "ANDROID_KEY_ALIAS", "ANDROID_KEY_PASSWORD", "ANDROID_KEYSTORE_PATH"]
    missing = [name for name in required if not os.environ.get(name)]
    if missing:
        print("Missing signing configuration: " + ", ".join(missing), file=sys.stderr)
        return 1
    try:
        key = base64.b64decode(os.environ["ANDROID_KEYSTORE_BASE64"], validate=True)
        if not key:
            raise ValueError("empty key")
    except ValueError:
        print("Invalid signing key encoding", file=sys.stderr)
        return 1
    path = Path(os.environ["ANDROID_KEYSTORE_PATH"])
    with path.open("xb") as output:
        path.chmod(0o600)
        output.write(key)
    return 0


if __name__ == "__main__":
    sys.exit(main())
