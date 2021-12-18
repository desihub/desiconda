# Install pip packages.
echo Installing pip packages at $(date)

pip install --no-binary :all: hpsspy
pip install threadpoolctl

# see https://docs.nersc.gov/development/languages/python/parallel-python/
MPICC="cc  -shared" pip install --force --no-cache-dir --no-binary=mpi4py mpi4py

if [ $? != 0 ]; then
    echo "ERROR installing pip packages; exiting"
    exit 1
fi

echo Current time $(date) Done installing conda packages
