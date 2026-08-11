#!/bin/bash

# Bootstrap installation of the main branch of a set of DESI modules

if [ -z "$DESICONDA" ] || [ -z "$DESICONDA_VERSION" ]; then
    echo "Load a desiconda module first to get \$DESICONDA and $DESICONDA_VERSION" >&2
    return
fi

# Install desiutil to get desiInstall script
# (will remove this later after installing the desiutil module)
pip install desiutil

if [[ "${NERSC_HOST}" == "datatran" ]]; then
    # NERSC Data Transfer Nodes have minimal environment
    pkgs="desiutil desitree desiBackup desidatamodel desitransfer desida"
    # MODULESHOME may be incorrectly set on datatran.
    if [[ -z "${MODULESHOME}" || ! -d ${MODULESHOME} ]]; then
        if [[ -d /usr/share/lmod/lmod ]]; then
            export MODULESHOME=/usr/share/lmod/lmod
        else
            echo "Could not determine the MODULESHOME directory!" >&2
            return
        fi
    fi
elif [ "${HOSTNAME}" == "desi-7" ] || [ "${HOSTNAME}" == "desi-8" ]; then
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
    if [ $pkg == "QuasarNP" ] ; then branch="0.2.0"; fi
    if [ $pkg == "desitree" ] ; then branch="0.7.0"; fi
    ### if [ $pkg ==   "specex" ] ; then branch="0.8.6"; fi

    echo desiInstall -v -r $base $pkg $branch
    desiInstall -v -r $base $pkg $branch

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

# remove pip desiutil because we'll use the desiutil module now
pip uninstall desiutil --yes
