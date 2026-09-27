import contextlib
import io
from pathlib import Path
import runpy
import unittest
from unittest.mock import Mock, patch


class CliTests(unittest.TestCase):
    def setUp(self):
        self.module = runpy.run_path(str(Path(__file__).resolve().parents[1] / "bin/agvpn"))
        self.g = self.module["main"].__globals__

    def invoke(self, argv, **overrides):
        defaults = dict(load_language=Mock(), have_cli=lambda: True)
        defaults.update(overrides)
        with patch.dict(self.g, defaults), contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
            try:
                return self.g["main"](argv)
            except SystemExit as exc:
                return exc.code

    def test_interrupt_at_startup_and_dispatch(self):
        for stage in ("load_language", "require_login", "main_menu", "dispatch"):
            for exception in (KeyboardInterrupt, EOFError):
                with self.subTest(stage=stage, exception=exception):
                    overrides = dict(require_login=lambda: True)
                    overrides[stage] = Mock(side_effect=exception)
                    self.assertEqual(self.invoke(["status"] if stage == "dispatch" else [], **overrides), 130)

    def test_interrupt_during_license_subprocess(self):
        with patch("subprocess.run", side_effect=KeyboardInterrupt):
            self.assertEqual(self.invoke([]), 130)

    def test_local_help_without_dependency_or_login(self):
        for argv in (["--help"], ["--version"], ["connect", "--help"], ["language", "--help"]):
            with self.subTest(argv=argv):
                login = Mock(side_effect=AssertionError("must not check login"))
                self.assertEqual(self.invoke(argv, have_cli=lambda: False, require_login=login), 0)

    def test_bad_language_arguments(self):
        for argv in (["language", "de"], ["language", "ru", "extra"]):
            self.assertEqual(self.invoke(argv), 2)

    def test_raw_help_cannot_bypass_authentication(self):
        live = Mock()
        self.assertEqual(self.invoke(["raw", "connect", "--help"], require_login=lambda: False, run_live=live), 1)
        live.assert_not_called()

    def test_connect_translation(self):
        for lang in ("en", "ru"):
            for kwargs in ({"fastest": True}, {"location": "Riga"}, {}):
                with patch.dict(self.g, LANG=lang, cli=Mock(return_value=(False, ""))), contextlib.redirect_stdout(io.StringIO()):
                    self.assertFalse(self.g["act_connect"](**kwargs))

    def test_exclusions_translation(self):
        for lang in ("en", "ru"):
            for output in ("Exclusions\n", "Exclusions\nexample.com"):
                with patch.dict(self.g, LANG=lang, run=Mock(return_value=(0, output, ""))), contextlib.redirect_stdout(io.StringIO()):
                    self.g["act_excl_show"]()


if __name__ == "__main__":
    unittest.main()
