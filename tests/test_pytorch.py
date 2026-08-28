"""Smoke tests for pytorch on CPU and GPU."""
import pytest


def test_torch_imports():
    import torch  # noqa: F401


def test_torch_cpu_computation():
    import torch

    result = torch.dot(torch.arange(5.0), torch.arange(5.0))
    assert float(result) == 30.0


def test_torch_gpu_computation(gpu_hardware):
    if not gpu_hardware:
        pytest.skip("no GPU hardware detected on this node")
    import torch

    assert torch.cuda.is_available(), "GPU hardware present but torch.cuda.is_available() is False"

    device = torch.device("cuda")
    result = torch.dot(torch.arange(5.0, device=device), torch.arange(5.0, device=device))
    assert float(result) == 30.0
