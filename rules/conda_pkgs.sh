conda install --copy --yes \
    nose \
    requests \
    future \
    cython \
    numpy \
    scipy \
    matplotlib \
    basemap \
    pyyaml \
    astropy \
    hdf5 \
    h5py \
    psutil \
    ephem \
    psycopg2 \
    numba=0.28.1 \
    && conda install --copy --yes -c defaults \
    ipython ipython-notebook \
    && rm -rf @CONDA_PREFIX@/pkgs/*
