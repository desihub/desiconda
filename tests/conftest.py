"""Shared fixtures for the desiconda environment smoke-test suite."""
import shutil
import subprocess

import pytest


def _gpu_hardware_present():
    """Detect GPU hardware independent of cupy/jax/etc, so a test can tell
    "no GPU on this node" (skip) apart from "GPU present but library can't
    use it" (real failure)."""
    nvidia_smi = shutil.which("nvidia-smi")
    if not nvidia_smi:
        return False
    try:
        result = subprocess.run(
            [nvidia_smi, "-L"], capture_output=True, text=True, timeout=15
        )
    except (OSError, subprocess.TimeoutExpired):
        return False
    return result.returncode == 0 and "GPU" in result.stdout


@pytest.fixture(scope="session")
def gpu_hardware():
    """True if this test session is running on a node with a visible GPU."""
    return _gpu_hardware_present()
