conda install --copy --yes \
    nose \
    requests \
    future \
    cython \
    numpy \
    scipy \
    matplotlib \
    seaborn \
    pyyaml \
    astropy=1.3.3 \
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
    && mplrc="@CONDA_PREFIX@/lib/python@PYVERSION@/site-packages/matplotlib/mpl-data/matplotlibrc"; \
    cat ${mplrc} | sed -e "s#^backend.*#backend : TkAgg#" > ${mplrc}.tmp; \
    mv ${mplrc}.tmp ${mplrc} \
    && conda install -c conda-forge --copy --yes basemap \
    && rm -rf @CONDA_PREFIX@/pkgs/*
