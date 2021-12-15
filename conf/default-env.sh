# export MINICONDA=https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# miniforge solves fast and works well with conda-forge 
export MINICONDA=https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh
export CONDAVERSION=2.0
export GRP=desi
export MPICC="cc -shared" # needed for mpi4py
export CONDAPRGENV=gnu

export CC="gcc"
export FC="gfortran"
export CFLAGS="-O3 -fPIC -pthread"
export FCFLAGS="-O3 -fPIC -pthread -fexceptions"
export NTMAKE=8

module unload darshan            # not necessary and suspected to generate overhead
module unload altd               # not necessary and suspected to cause random job hangs
module unload craype-hugepages2M # https://docs.nersc.gov/development/languages/python/faq-troubleshooting
