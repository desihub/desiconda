# Install pip packages.
echo Installing pip packages at $(date)

#- SB 2024-03-22: previous hpsspy install method fails, but basic install works
# pip install --no-binary :all: hpsspy
pip install hpsspy

# See https://developer.nvidia.com/blog/cuda-python-1-0-stable-apis-one-foundation-full-platform-access/
pip install cuda-python cuda-cccl numba numba-cuda-mlir[cu13] cupy-cuda13X

pip install threadpoolctl

# see https://docs.nersc.gov/development/languages/python/parallel-python/
pip install --force --no-cache-dir --no-binary=mpi4py mpi4py

if [ $? != 0 ]; then
    echo "ERROR installing pip packages; exiting"
    exit 1
fi

echo Current time $(date) Done installing pip packages
