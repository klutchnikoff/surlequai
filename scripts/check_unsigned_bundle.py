"""Reject signed bundles before publishing CI artifacts or signing locally."""
from pathlib import Path
import sys
import zipfile


def check_unsigned(path):
    with zipfile.ZipFile(path) as bundle:
        names = {name.upper() for name in bundle.namelist()}
        if 'BUNDLECONFIG.PB' not in names or 'BASE/MANIFEST/ANDROIDMANIFEST.XML' not in names:
            raise ValueError('Not an Android App Bundle')
        for name in names:
            if name.startswith('META-INF/'):
                leaf = name[len('META-INF/'):]
                if '/' not in leaf and (leaf.endswith(('.SF', '.RSA', '.DSA', '.EC')) or leaf.startswith('SIG-')):
                    raise ValueError('Bundle already contains a signature')


if __name__ == '__main__':
    check_unsigned(Path(sys.argv[1]))
    print('Unsigned Android bundle verified')
