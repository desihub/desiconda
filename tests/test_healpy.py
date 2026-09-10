"""Smoke test that healpy is installed and its pixelization functions are
self-consistent (nside/npix relation, and an ang2pix/pix2ang roundtrip)."""
import pytest


def test_healpy_imports():
    import healpy  # noqa: F401


def test_healpy_nside2npix():
    hp = pytest.importorskip("healpy")

    assert hp.nside2npix(64) == 12 * 64**2


def test_healpy_pixel_roundtrip():
    hp = pytest.importorskip("healpy")

    nside, pix = 64, 100
    theta, phi = hp.pix2ang(nside, pix)
    assert hp.ang2pix(nside, theta, phi) == pix
