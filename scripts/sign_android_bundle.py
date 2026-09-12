"""Sign a downloaded bundle locally; jarsigner prompts for passwords."""
import argparse
import hashlib
from pathlib import Path
import subprocess
import tempfile

from check_unsigned_bundle import check_unsigned


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('bundle', type=Path)
    parser.add_argument('--keystore', required=True, type=Path)
    parser.add_argument('--alias', required=True)
    args = parser.parse_args()
    check_unsigned(args.bundle)
    if not args.keystore.is_file():
        parser.error('Keystore not found')
    root = Path(__file__).resolve().parents[1]
    destination = root / 'play-release' / 'signed'
    destination.mkdir(parents=True, exist_ok=True)
    output = destination / (args.bundle.stem.removesuffix('-unsigned') + '.aab')
    if output.exists():
        parser.error(f'Output already exists: {output}')
    with tempfile.TemporaryDirectory(dir=destination) as temporary:
        signed = Path(temporary) / 'signed.aab'
        subprocess.run([
            'jarsigner', '-keystore', str(args.keystore.resolve()),
            '-signedjar', str(signed), str(args.bundle.resolve()), args.alias,
        ], check=True)
        subprocess.run(['jarsigner', '-verify', str(signed)], check=True)
        # Exclusive creation prevents replacing a previously prepared release.
        with output.open('xb') as target:
            target.write(signed.read_bytes())
    digest = hashlib.sha256(output.read_bytes()).hexdigest()
    output.with_suffix('.aab.sha256').write_text(f'{digest}  {output.name}\n')
    print(f'Signed bundle: {output}')


if __name__ == '__main__':
    main()
