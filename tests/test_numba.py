"""Smoke test that numba can JIT-compile and run a function in nopython
mode (not silently falling back to the pure-Python object-mode path).

conf/pip-pkgs.sh installs numba-cuda-mlir without the [cu13] extra; it is
expected to find CUDA via NERSC's cudatoolkit module instead. If GPU
hardware is present but test_numba_cuda_gpu_computation fails, check that
a compatible cudatoolkit module is loaded.
"""

import numpy as np
import pytest


def test_numba_jit_compiles_and_runs():
    import numba

    @numba.njit
    def sum_of_squares(n):
        total = 0.0
        for i in range(n):
            total += i * i
        return total

    result = sum_of_squares(100)
    expected = sum(i * i for i in range(100))

    assert result == expected
    assert sum_of_squares.nopython_signatures, "function did not compile in nopython mode"


def test_numba_cuda_gpu_computation(gpu_hardware):
    if not gpu_hardware:
        pytest.skip("no GPU hardware detected on this node")

    from numba import cuda

    assert cuda.is_available(), "GPU hardware present but numba reports no CUDA backend"

    @cuda.jit
    def add_squares(x, out):
        i = cuda.grid(1)
        if i < x.size:
            out[i] = x[i] * x[i]

    n = 10
    x = np.arange(n, dtype=np.float64)
    out = np.zeros_like(x)

    add_squares[1, n](x, out)

    assert np.array_equal(out, x**2)
