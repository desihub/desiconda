# conda packages
echo Current time $(date) Installing conda packages
echo condadir is $CONDADIR

# Notes:
# - cupy-core instead of cupy so that it won't install any cuda libraries,
#   which we will get from NERSC cudatoolkit module instead
# - OLD: mkl=2020.0 because that is the last version that guarantees bitwise
#   identical output for bitwise idential input
# - bokeh<3 because nightwatch doesn't yet support bokeh 3
# - ucx constraint is to avoid bringing in cuda libraries due to mal-formed
#   dependencies "dask -> pyarrow -> libarrow -> ucx"
#   https://github.com/conda-forge/ucx-split-feedstock/issues/172
#
# - changes on 2025-02-20:
#   - removed numpy<2 pin
#   - removed mkl=2020.0 pin (alas, more recent versions don't guarantee
#     bitwise reproducibility even on identical inputs)
#   - Move to openblas+openmp instead of mkl
#   - Added numba-cuda in addition to numba (future-proofing)
#   - Added pytest-xdist for pytest parallelism
#   - Added setuptools-scm to support desiInstall speclite and specsim (desiutil #227)
#   - Added ipympl for interactive plotting in jupyter

conda install --copy --yes -c conda-forge \
    astropy \
    fitsio \
    fitsverify \
    "libblas=*=*_openblas" \
    "libopenblas=*=*openmp*" \
    "openblas=*=*openmp*" \
    dask \
    "ucx=1.14.1=*_0" \
    distributed \
    setuptools-scm \
    papermill \
    nose \
    requests \
    future \
    cython \
    cmake \
    numpy \
    scipy \
    intel-openmp \
    matplotlib \
    ipympl \
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
    pytest-xdist \
    numba \
    numba-cuda \
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
    sphinx_rtd_theme \
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
    mkdocs-material \
    pymdown-extensions \
    altair \
    vega_datasets \
    conda-tree \
    setuptools-scm \
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
