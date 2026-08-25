# Minimal conda packages for fast install.sh iteration/testing of module
# and environment-variable behavior. Not for production use. Select with
# PKGS=fast.
echo Current time $(date) Installing fast/minimal test packages
echo condadir is $CONDADIR

conda install --copy --yes -c conda-forge \
    numpy \
    astropy \
    pytest \
&& rm -rf $CONDADIR/pkgs/*

if [ $? != 0 ]; then
    echo "ERROR installing conda packages; exiting"
    exit 1
fi

conda list --export | grep -v conda > "$CONDADIR/pkg_list.txt"
echo Current time $(date) Done installing fast/minimal test packages
