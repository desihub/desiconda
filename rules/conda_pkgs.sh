conda install --copy --yes \
    nose \
    requests \
    numpy \
    scipy \
    matplotlib \
    pyyaml \
    astropy \
    hdf5 \
    h5py \
    ipython-notebook \
    psutil \
    numba=0.28.1 \
    && rm -rf @CONDA_PREFIX@/pkgs/*
