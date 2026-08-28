"""Smoke test that healpy is installed and its pixelization functions are
self-consistent (nside/npix relation, and an ang2pix/pix2ang roundtrip)."""


def test_healpy_nside2npix():
    import healpy as hp

    assert hp.nside2npix(64) == 12 * 64**2


def test_healpy_pixel_roundtrip():
    import healpy as hp

    nside, pix = 64, 100
    theta, phi = hp.pix2ang(nside, pix)
    assert hp.ang2pix(nside, theta, phi) == pix
