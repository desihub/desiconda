# conda packages
echo Current time $(date) Installing conda packages
echo condadir is $CONDADIR

conda install --copy --yes -c conda-forge \
    astropy \
    fitsio \
    fitsverify \
    libblas=*=*mkl \
    dask \
    distributed \
    papermill \
    nose \
    requests \
    future \
    cython \
    cmake \
    "numpy<2.0" \
    scipy \
    intel-openmp \
    mkl=2020.0 \
    matplotlib \
    seaborn \
    pyyaml \
    pytest-astropy \
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
    "bokeh<3" \
    wurlitzer \
    certipy \
    sphinx \
    iminuit \
    cupy \
    healpy \
    photutils \
    specutils \
    xlrd \
    coveralls \
    configobj \
    line_profiler \
    galsim \
    mkdocs \
    altair \
    vega_datasets \
&& mplrc="$CONDADIR/lib/python$PYVERSION/site-packages/matplotlib/mpl-data/matplotlibrc"; \
    cat ${mplrc} | sed -e "s#^backend.*#backend : TkAgg#" > ${mplrc}.tmp; \
    mv ${mplrc}.tmp ${mplrc} \
&& rm -rf $CONDADIR/pkgs/*

if [ $? != 0 ]; then
    echo "ERROR installing conda packages; exiting"
    exit 1
fi

conda list --export | grep -v conda > "$CONDADIR/pkg_list.txt"
echo Current time $(date) Done installing conda packages
