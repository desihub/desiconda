# conda packages
echo Current time $(date) Installing conda packages
echo condadir is $CONDADIR

# Notes:
# - cupy-core instead of cupy so that it won't install any cuda libraries,
#   which we will get from NERSC cudatoolkit module instead
# - mkl=2020.0 because that is the last version that guarantees bitwise
#   identical output for bitwise idential input
# - bokeh<3 because prospect and nightwatch don't yet support bokeh 3
# - numpy<2.0 because we haven't tested with numpy 2.x yet.
# - ucx constraint is to avoid bringing in cuda libraries due to mal-formed
#   dependencies "dask -> pyarrow -> libarrow -> ucx"
#   https://github.com/conda-forge/ucx-split-feedstock/issues/172

conda install --copy --yes -c conda-forge \
    astropy \
    fitsio \
    fitsverify \
    libblas=*=*mkl \
    dask \
    "ucx=1.14.1=*_0" \
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
    cupy-core \
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
    conda-tree \
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
