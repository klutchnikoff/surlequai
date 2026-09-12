import sys
from pathlib import Path
import tempfile
import unittest
import zipfile

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from check_unsigned_bundle import check_unsigned


class UnsignedBundleTest(unittest.TestCase):
    def test_bundle_signatures_are_rejected(self):
        for signature in (None, 'META-INF/CERT.SF', 'META-INF/cert.rsa',
                          'META-INF/CERT.DSA', 'META-INF/CERT.EC', 'META-INF/SIG-CUSTOM'):
            with self.subTest(signature=signature), tempfile.TemporaryDirectory() as directory:
                path = Path(directory) / 'app.aab'
                with zipfile.ZipFile(path, 'w') as bundle:
                    bundle.writestr('BundleConfig.pb', b'')
                    bundle.writestr('base/manifest/AndroidManifest.xml', b'')
                    if signature:
                        bundle.writestr(signature, b'')
                if signature:
                    with self.assertRaises(ValueError):
                        check_unsigned(path)
                else:
                    check_unsigned(path)

    def test_arbitrary_zip_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'app.aab'
            with zipfile.ZipFile(path, 'w'):
                pass
            with self.assertRaises(ValueError):
                check_unsigned(path)
