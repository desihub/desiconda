"""Smoke test that numba can JIT-compile and run a function in nopython
mode (not silently falling back to the pure-Python object-mode path)."""


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
