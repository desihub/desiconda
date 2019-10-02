conda install --copy --yes \
    nose \
    requests \
    future \
    cython \
    cmake \
    numpy \
    scipy \
    matplotlib=2.1.2 \
    basemap \
    seaborn \
    pyyaml \
    astropy=2 \
    hdf5 \
    h5py \
    psutil \
    ephem \
    psycopg2 \
    pytest=3.6.2 \
    pytest-cov \
    numba \
    sqlalchemy \
    scikit-learn \
    scikit-image \
    ipython \
    jupyter \
    ipywidgets \
    bokeh \
    && conda install --copy --yes -c conda-forge dask distributed \
    && mplrc="@CONDA_PREFIX@/lib/python@PYVERSION@/site-packages/matplotlib/mpl-data/matplotlibrc"; \
    cat ${mplrc} | sed -e "s#^backend.*#backend : TkAgg#" > ${mplrc}.tmp; \
    mv ${mplrc}.tmp ${mplrc} \
    && rm -rf @CONDA_PREFIX@/pkgs/*
