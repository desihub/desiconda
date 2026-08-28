"""Smoke tests that mkdocs is installed with a working mkdocs-material
theme, and that the two can build a minimal site end-to-end."""
import importlib.metadata
import subprocess
import sys


def test_mkdocs_imports():
    import mkdocs  # noqa: F401


def test_mkdocs_material_theme_registered():
    theme_names = {ep.name for ep in importlib.metadata.entry_points(group="mkdocs.themes")}
    assert "material" in theme_names, (
        "mkdocs-material is not registered as an mkdocs theme "
        f"(found themes: {sorted(theme_names)})"
    )


def test_mkdocs_material_builds_site(tmp_path):
    docs_dir = tmp_path / "docs"
    docs_dir.mkdir()
    (docs_dir / "index.md").write_text("# Hello\n\nThis is a smoke-test page.\n")
    (tmp_path / "mkdocs.yml").write_text("site_name: desiconda smoke test\ntheme:\n  name: material\n")

    site_dir = tmp_path / "site"
    result = subprocess.run(
        [sys.executable, "-m", "mkdocs", "build", "-d", str(site_dir)],
        cwd=tmp_path,
        capture_output=True,
        text=True,
        timeout=120,
    )

    assert result.returncode == 0, (
        f"mkdocs build failed:\nstdout:\n{result.stdout}\nstderr:\n{result.stderr}"
    )
    assert (site_dir / "index.html").exists()
