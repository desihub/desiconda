"""Smoke tests for matplotlib and bokeh, including a regression check for
desihub/desiconda#82 (bokeh's numpy-array serialization breaking when bokeh
and numpy versions drift out of sync)."""
import numpy as np


def test_matplotlib_can_render_figure(tmp_path):
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    fig, ax = plt.subplots()
    ax.plot(np.arange(10), np.arange(10) ** 2)
    outfile = tmp_path / "plot.png"
    fig.savefig(outfile)
    plt.close(fig)

    assert outfile.exists()
    assert outfile.stat().st_size > 0


def test_bokeh_can_render_figure():
    from bokeh.embed import file_html
    from bokeh.plotting import figure
    from bokeh.resources import CDN

    p = figure(title="desiconda smoke test")
    p.line(x=np.arange(10), y=np.arange(10) ** 2)
    html = file_html(p, CDN, "desiconda smoke test")

    assert "<script" in html


def test_bokeh_numpy_data_serialization():
    """conf/conda-pkgs.sh notes that bokeh<3 broke when paired with a newer
    numpy (desihub/desiconda#82); this exercises the same numpy-array ->
    ColumnDataSource -> glyph serialization path that failed then."""
    from bokeh.models import ColumnDataSource
    from bokeh.plotting import figure

    y = np.random.default_rng(0).normal(size=20)
    source = ColumnDataSource(data=dict(x=np.arange(20), y=y))
    p = figure()
    p.scatter(x="x", y="y", source=source)

    assert len(source.data["y"]) == 20
    assert np.allclose(source.data["y"], y)
