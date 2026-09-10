"""Smoke tests that cupy is installed and can use the GPU.

conf/pip-pkgs.sh installs cupy-cuda13x; it is expected to find CUDA via NERSC's
cudatoolkit module instead. If GPU hardware is present but
test_cupy_gpu_computation fails, check that a compatible cudatoolkit
module is loaded.
"""
import pytest


def test_cupy_imports():
    import cupy  # noqa: F401


def test_cupy_gpu_computation(gpu_hardware):
    if not gpu_hardware:
        pytest.skip("no GPU hardware detected on this node")
    cupy = pytest.importorskip("cupy")

    a = cupy.arange(10)
    result = int((a**2).sum())
    assert result == sum(i * i for i in range(10))
    assert cupy.cuda.runtime.getDeviceCount() > 0
