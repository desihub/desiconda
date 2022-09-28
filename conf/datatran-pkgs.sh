# conda packages
echo Current time $(date) Installing conda packages
echo condadir is $CONDADIR

conda install --copy --yes -c conda-forge \
    astropy \
    fitsio \
    fitsverify \
    matplotlib \
    requests \
    pyyaml \
    hdf5 \
    h5py \
    healpy \
    sphinx \
    pytest \
    pytest-cov \
    pytest-astropy \
    coveralls \
    && rm -rf $CONDADIR/pkgs/*

if [ $? != 0 ]; then
    echo "ERROR installing conda packages; exiting"
    exit 1
fi

conda list --export | grep -v conda > "$CONDADIR/pkg_list.txt"
echo Current time $(date) Done installing conda packages

# Install pip packages.
echo Installing pip packages at $(date)

pip install hpsspy sphinx-toolbox

if [ $? != 0 ]; then
    echo "ERROR installing pip packages; exiting"
    exit 1
fi

echo Current time $(date) Done installing pip packages
