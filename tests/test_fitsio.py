"""Smoke test that fitsio can write and read back a FITS binary table."""
import numpy as np


def test_fitsio_write_read_roundtrip(tmp_path):
    import fitsio

    data = np.array([(1, 2.5), (2, 3.5)], dtype=[("a", "i4"), ("b", "f8")])
    outfile = tmp_path / "test.fits"

    fitsio.write(str(outfile), data, extname="TEST", clobber=True)
    result = fitsio.read(str(outfile), ext="TEST")

    assert np.array_equal(result["a"], data["a"])
    assert np.allclose(result["b"], data["b"])
