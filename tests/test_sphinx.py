"""Smoke tests that sphinx is installed with a working sphinx_rtd_theme, and
that the two can build a minimal site end-to-end."""
import importlib.metadata
import subprocess
import sys


def test_sphinx_imports():
    import sphinx  # noqa: F401


def test_sphinx_rtd_theme_registered():
    theme_names = {ep.name for ep in importlib.metadata.entry_points(group="sphinx.html_themes")}
    assert "sphinx_rtd_theme" in theme_names, (
        "sphinx_rtd_theme is not registered as a sphinx html theme "
        f"(found themes: {sorted(theme_names)})"
    )


def test_sphinx_rtd_theme_builds_site(tmp_path):
    src_dir = tmp_path / "src"
    src_dir.mkdir()
    (src_dir / "conf.py").write_text(
        "project = 'desiconda smoke test'\nhtml_theme = 'sphinx_rtd_theme'\n"
    )
    (src_dir / "index.rst").write_text("Hello\n=====\n\nThis is a smoke-test page.\n")

    build_dir = tmp_path / "build"
    result = subprocess.run(
        [sys.executable, "-m", "sphinx", "-b", "html", str(src_dir), str(build_dir)],
        capture_output=True,
        text=True,
        timeout=120,
    )

    assert result.returncode == 0, (
        f"sphinx build failed:\nstdout:\n{result.stdout}\nstderr:\n{result.stderr}"
    )
    assert (build_dir / "index.html").exists()
    assert (build_dir / "_static" / "css" / "theme.css").exists(), (
        "index.html built, but sphinx_rtd_theme's theme.css is missing "
        "(site may have fallen back to the default theme)"
    )
