# desiconda environment smoke tests

Basic functionality checks for an installed/loaded desiconda module: each
package imports cleanly and can do one small, correctness-checked
computation. Not exhaustive, and not meant to fix problems it finds -
just to surface them (e.g. a package missing, or a version mismatch
between two packages).

## Running

```
module load desiconda/<version>
python -m pytest tests/ -v
```

## GPU tests (cupy, jax, pytorch)

`tests/conftest.py` detects real GPU hardware via `nvidia-smi`, independent
of cupy/jax/pytorch themselves. That lets the GPU tests tell apart two
different situations:

- No GPU hardware on this node (e.g. a login node) -> test is **skipped**.
- GPU hardware is present but cupy/jax can't use it (e.g. `cudatoolkit`
  module not loaded, or a version mismatch) -> test **fails**, since that's
  a real problem worth fixing.

Run on a GPU node/allocation to exercise these paths.

