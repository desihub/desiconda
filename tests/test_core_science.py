"""Smoke tests for numpy, scipy, astropy, and pandas: importable, and each
can do one basic, correctness-checked computation."""
import numpy as np


def test_numpy_basic_computation():
    a = np.arange(10)
    assert a.sum() == 45
    assert np.isclose(np.linalg.norm([3, 4]), 5.0)


def test_scipy_basic_computation():
    from scipy import integrate

    value, _ = integrate.quad(lambda x: x**2, 0, 1)
    assert np.isclose(value, 1 / 3, atol=1e-6)


def test_astropy_basic_computation():
    from astropy import units as u
    from astropy.coordinates import SkyCoord

    c1 = SkyCoord(ra=10 * u.deg, dec=0 * u.deg)
    c2 = SkyCoord(ra=10 * u.deg, dec=1 * u.deg)
    assert np.isclose(c1.separation(c2).deg, 1.0, atol=1e-6)


def test_pandas_basic_computation():
    import pandas as pd

    df = pd.DataFrame({"x": np.arange(5), "y": np.arange(5) * 2})
    assert df["y"].sum() == 20


def test_pandas_numpy_interop():
    """Exercises the numpy<->pandas data path (dtype/ABI compatibility)."""
    import pandas as pd

    arr = np.random.default_rng(0).normal(size=100)
    s = pd.Series(arr)
    assert np.isclose(s.mean(), arr.mean())
    assert np.allclose(s.to_numpy(), arr)
