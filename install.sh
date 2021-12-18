#!/bin/bash

while getopts "v" opt; do
    case $opt in
	v) set -x # print commands as they are run so we know where we are if something fails
	   ;;
    esac
done
echo Starting desiconda installation at $(date)
SECONDS=0

# Defaults
if [ -z $CONF ] ; then CONF=default; fi
if [ -z $PKGS ] ; then PKGS=default; fi

# Script directory
pushd $(dirname $0) > /dev/null
topdir=$(pwd)
popd > /dev/null

scriptname=$(basename $0)
fullscript="${topdir}/${scriptname}"

# Convenience environment variables
SWAPPRGENV=$topdir/scripts/SwapPrgEnv.sh

CONFDIR=$topdir/conf

CONFIGUREENV=$CONFDIR/$CONF-env.sh
INSTALLPKGS=$CONFDIR/$PKGS-pkgs.sh

export PATH=$CONDADIR/bin:$PATH

# Initialize environment
source $CONFIGUREENV

# Swap modules
source $SWAPPRGENV

# Set installation directories
DESICONDA=$PREFIX/$DCONDAVERSION
CONDADIR=$DESICONDA/conda
AUXDIR=$DESICONDA/aux
MODULEDIR=$DESICONDA/modulefiles/desiconda

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

# Install packages
source $INSTALLPKGS

# Compile python modules
echo Pre-compiling python modules at $(date)

python$PYVERSION -m compileall -f "$CONDADIR/lib/python$PYVERSION/site-packages"

# Set permissions
echo Setting permissions at $(date)

chgrp -R $GRP $CONDADIR
chmod -R u=rwX,g=rX,o-rwx $CONDADIR

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
chmod -R u=rwX,g=rX,o-rwx $MODULEDIR

# All done
echo Done at $(date)
duration=$SECONDS
echo "Installation took $(($duration / 60)) minutes and $(($duration % 60)) seconds."
