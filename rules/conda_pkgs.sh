conda install --copy --yes \
    nose \
    requests \
    future \
    cython \
    cmake \
    numpy \
    scipy \
    matplotlib \
    basemap \
    seaborn \
    pyyaml \
    astropy \
    hdf5 \
    h5py \
    psutil \
    ephem \
    psycopg2 \
    pytest \
    pytest-cov \
    numba \
    sqlalchemy \
    scikit-learn \
    scikit-image \
    ipython \
    jupyter \
    ipywidgets \
    bokeh \
    wurlitzer \
    certipy \
    sphinx \
    iminuit \
    cudatoolkit \
    && conda install --copy --yes -c conda-forge dask distributed papermill \
    && mplrc="@CONDA_PREFIX@/lib/python@PYVERSION@/site-packages/matplotlib/mpl-data/matplotlibrc"; \
    cat ${mplrc} | sed -e "s#^backend.*#backend : TkAgg#" > ${mplrc}.tmp; \
    mv ${mplrc}.tmp ${mplrc} \
    && rm -rf @CONDA_PREFIX@/pkgs/*
