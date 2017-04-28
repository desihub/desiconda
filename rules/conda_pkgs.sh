conda install --copy --yes \
    nose \
    requests \
    future \
    numpy \
    scipy \
    matplotlib \
    pyyaml \
    astropy \
    hdf5 \
    h5py \
    ipython-notebook \
    psutil \
    ephem \
    numba=0.28.1 \
    && rm -rf @CONDA_PREFIX@/pkgs/*
