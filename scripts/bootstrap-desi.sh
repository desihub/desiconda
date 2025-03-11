#!/bin/bash

# Bootstrap installation of the main branch of a set of DESI modules

if [ -z "$DESICONDA" ] || [ -z "$DESICONDA_VERSION" ]; then
    echo "Load a desiconda module first to get \$DESICONDA and $DESICONDA_VERSION"
    return
fi

iskpno=false
if [[ "$HOSTNAME" == "desi-7" ]] || [[ "$HOSTNAME" == "desi-8" ]]; then
    if [ "$USER" == "datasystems" ]; then
        iskpno=true
    else
        echo "At KPNO, must run as datasystems."
        return
    fi
fi

# Install desiutil to get desiInstall script
# (will remove this later after installing the desiutil module)
# Note that special instructions are needed at KPNO (desi-8).
if [ $iskpno == true ]; then
    ssh git@desi-general git -C desiutil fetch
    git clone git@desi-general:desiutil
    pip install -e desiutil
else
     pip install git+https://github.com/desihub/desiutil.git
fi

if [[ "${NERSC_HOST}" == "datatran" ]]; then
    # NERSC Data Transfer Nodes have minimal environment
    pkgs="desiutil desitree desiBackup desidatamodel desitransfer desida"
elif [ $iskpno == true ]; then
    # KPNO have most packages, but not specex QuasarNP, ...
    pkgs="desiutil desitree desispec specter gpu_specter desimodel desitarget specsim desisim fiberassign desisurvey surveysim redrock redrock-templates prospect desimeter simqso speclite nightwatch"
else
    # Default is everything
    pkgs="desiutil desitree desispec specter gpu_specter desimodel desitarget specsim desisim fiberassign desisurvey surveysim redrock redrock-templates prospect desimeter simqso speclite specex QuasarNP desisim-testdata desisurveyops specprod-db fastspecfit gfa_reduce desiBackup desida desidatamodel"
fi

export DESI_SPX_MKL=true
base=$(realpath $DESICONDA/..)
for pkg in $pkgs; do
    # install branches/main
    echo desiInstalling $pkg
    branch=branches/main

    # some packages we special-case to tagged versions
    if [ $pkg == "QuasarNP" ] ; then branch="0.1.5"; fi
    if [ $pkg == "desitree" ] ; then branch="0.6.0"; fi
    ### if [ $pkg ==   "specex" ] ; then branch="0.8.6"; fi

    # Special instructions at KPNO
    if [ $iskpno == true ]; then
        echo desiInstall -v -p $pkg:git@desi-general:$pkg -r $base $pkg $branch
        desiInstall -v -p $pkg:git@desi-general:$pkg -r $base $pkg $branch
    else
        desiInstall -v -r $base $pkg $branch
    fi

    # special case to compile specex and fiberassign main
    if [ $pkg == "specex" ] ; then
        module load specex/main
        pushd $SPECEX
        python setup.py build_ext --inplace
        popd
    fi

    if [ $pkg == "fiberassign" ] ; then
        module load fiberassign/main
        pushd $FIBERASSIGN
        python setup.py build_ext --inplace
        popd
    fi
done

# install dust module from an earlier version of desiconda
if [ $iskpno == false ]; then
    pushd $PREFIX
    cp -r 20230111-2.1.0/modulefiles/dust $DCONDAVERSION/modulefiles/
    popd
fi

# remove pip desiutil because we'll use the desiutil module now
pip uninstall desiutil --yes
