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
    && rm -rf @CONDA_PREFIX@/pkgs/*
