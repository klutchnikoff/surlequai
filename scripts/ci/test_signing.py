import base64
import contextlib
import io
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
from prepare_signing import main


class SigningPreparationTest(unittest.TestCase):
    def test_missing_secret_fails_without_creating_key(self):
        with patch.dict(os.environ, {}, clear=True), contextlib.redirect_stderr(io.StringIO()):
            self.assertEqual(main(), 1)

    def test_invalid_encoding_does_not_leak_the_value(self):
        output = io.StringIO()
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'key.jks'
            env = self.environment(path, 'not!base64-secret')
            with patch.dict(os.environ, env, clear=True), contextlib.redirect_stderr(output):
                self.assertEqual(main(), 1)
            self.assertFalse(path.exists())
            self.assertNotIn('not!base64-secret', output.getvalue())

    def test_key_is_private_and_cannot_overwrite_an_existing_file(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'key.jks'
            env = self.environment(path, base64.b64encode(b'synthetic-test-key').decode())
            with patch.dict(os.environ, env, clear=True):
                self.assertEqual(main(), 0)
                self.assertEqual(path.read_bytes(), b'synthetic-test-key')
                self.assertEqual(path.stat().st_mode & 0o777, 0o600)
                with self.assertRaises(FileExistsError):
                    main()

    @staticmethod
    def environment(path, encoded):
        return {'ANDROID_KEYSTORE_BASE64': encoded,
                'ANDROID_KEYSTORE_PASSWORD': 'test', 'ANDROID_KEY_ALIAS': 'test',
                'ANDROID_KEY_PASSWORD': 'test', 'ANDROID_KEYSTORE_PATH': str(path)}


if __name__ == '__main__':
    unittest.main()
