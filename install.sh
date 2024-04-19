#!/bin/bash

while getopts "v" opt; do
    case $opt in
	v) set -x # print commands as they are run so we know where we are if something fails
	   ;;
    esac
done
echo Starting desiconda installation at $(date)
SECONDS=0

# Print every command run as part of log
set -o xtrace

# Defaults
if [ -z $CONF ] ; then CONF=nersc;   fi
if [ -z $PKGS ] ; then PKGS=default; fi

# Script directory
pushd $(dirname $0) > /dev/null
topdir=$(pwd)
popd > /dev/null

scriptname=$(basename $0)
fullscript="${topdir}/${scriptname}"

CONFDIR=$topdir/conf

CONFIGUREENV=$CONFDIR/$CONF-env.sh
INSTALLPKGS=$CONFDIR/$PKGS-pkgs.sh

# Initialize environment
source $CONFIGUREENV

# Set installation directories
DESICONDA=$PREFIX/$DCONDAVERSION
CONDADIR=$DESICONDA/conda
AUXDIR=$DESICONDA/aux
MODULEDIR=$DESICONDA/modulefiles/desiconda

export PATH=$CONDADIR/bin:$PATH

# Install conda root environment
echo Installing conda root environment at $(date)

mkdir -p $AUXDIR/bin
mkdir -p $AUXDIR/lib

mkdir -p $CONDADIR/bin
mkdir -p $CONDADIR/lib

curl -SL $MINICONDA \
  -o miniconda.sh \
  && /bin/bash miniconda.sh -b -f -p $CONDADIR

source $CONDADIR/bin/activate
export PYVERSION=$(python -c "import sys; print(str(sys.version_info[0])+'.'+str(sys.version_info[1]))")
echo Using Python version $PYVERSION

## Update to latest conda
# conda update -n base -c conda-forge conda

## Prior to installing packages, switch to the fast libmamba package solver.
## Disabled because miniconda how includes the mamba solver by default
#
# echo Installing the libmamba package solver
# conda config --set solver classic
# conda install -n base conda-libmamba-solver -y
# conda config --set solver libmamba

# Install packages
source $INSTALLPKGS

# Compile python modules
echo Pre-compiling python modules at $(date)

python$PYVERSION -m compileall -f "$CONDADIR/lib/python$PYVERSION/site-packages"

# Set permissions
echo Setting permissions at $(date)

chgrp -R $GRP $CONDADIR
chmod -R u=rwX,g=rX,o=rX $CONDADIR

# Install modulefile
echo Installing the desiconda modulefile at $(date)

mkdir -p $MODULEDIR

cp $topdir/modulefile.gen desiconda.module

sed -i 's@_CONDADIR_@'"$CONDADIR"'@g' desiconda.module
sed -i 's@_AUXDIR_@'"$AUXDIR"'@g' desiconda.module
sed -i 's@_DCONDAVERSION_@'"$DCONDAVERSION"'@g' desiconda.module
sed -i 's@_PYVERSION_@'"$PYVERSION"'@g' desiconda.module
sed -i 's@_CONDAPRGENV_@'"$CONDAPRGENV"'@g' desiconda.module

cp desiconda.module $MODULEDIR/$DCONDAVERSION
cp desiconda.modversion $MODULEDIR/.version_$DCONDAVERSION

chgrp -R $GRP $MODULEDIR
chmod -R u=rwX,g=rX,o=rx $MODULEDIR

# All done
echo Done at $(date)
duration=$SECONDS
echo "Installation took $(($duration / 60)) minutes and $(($duration % 60)) seconds."
