"""Smoke tests for jax on CPU and GPU."""
import pytest


def test_jax_imports():
    import jax  # noqa: F401


def test_jax_cpu_computation():
    jax = pytest.importorskip("jax")
    import jax.numpy as jnp

    with jax.default_device(jax.devices("cpu")[0]):
        result = jnp.dot(jnp.arange(5.0), jnp.arange(5.0))

    assert float(result) == 30.0


def test_jax_gpu_computation(gpu_hardware):
    if not gpu_hardware:
        pytest.skip("no GPU hardware detected on this node")
    jax = pytest.importorskip("jax")
    import jax.numpy as jnp

    try:
        gpu_devices = jax.devices("gpu")
    except RuntimeError as exc:
        pytest.fail(f"GPU hardware present but jax has no GPU backend: {exc}")

    assert gpu_devices, "GPU hardware present but jax reports no GPU devices"

    with jax.default_device(gpu_devices[0]):
        result = jnp.dot(jnp.arange(5.0), jnp.arange(5.0))

    assert float(result) == 30.0
