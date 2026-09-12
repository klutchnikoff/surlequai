import unittest
from check_release import validate


class ReleaseValidationTest(unittest.TestCase):
    def test_exact_tag(self):
        self.assertEqual(validate('version: 0.12.0+2006\n', 'v0.12.0+2006', ['v0.12.0+2005', 'v0.12.0+2006']), '0.12.0+2006')

    def test_mismatch_or_missing_build(self):
        for tag in ['v0.12.0', 'v0.12.0+2005', 'main', 'v0.12.0+2006\n']:
            with self.subTest(tag=tag), self.assertRaises(ValueError):
                validate('version: 0.12.0+2006', tag, [])

    def test_invalid_version(self):
        for version in ['', '0.12.0', '0.12.0+0', '0.12.0+2100000001', '0.12.0+2;echo']:
            with self.subTest(version=version), self.assertRaises(ValueError):
                validate('version: ' + version, 'v' + version, [])

    def test_build_cannot_be_reused_for_another_version(self):
        with self.assertRaises(ValueError):
            validate('version: 0.13.0+2005', 'v0.13.0+2005', ['v0.12.0+2005'])

    def test_build_cannot_decrease(self):
        with self.assertRaises(ValueError):
            validate('version: 0.13.0+2005', 'v0.13.0+2005', ['v0.12.0+2006'])

    def test_legacy_tags_without_build_are_ignored(self):
        self.assertEqual(validate('version: 0.12.0+2006', 'v0.12.0+2006', ['v0.11.0']), '0.12.0+2006')


if __name__ == '__main__':
    unittest.main()
