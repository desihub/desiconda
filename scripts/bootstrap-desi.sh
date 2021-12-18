#!/bin/bash

# Bootstrap a set of DESI modules for their master branch

if [ -z "$DESICONDA" ] || [ -z "$DESICONDA_VERSION" ]; then
    echo "Load a desiconda module first to get \$DESICONDA and $DESICONDA_VERSION"
    return
fi

# Install desiutil to get desiInstall script
pip install git+https://github.com/desihub/desiutil.git

pkgs="desiutil desitree desispec specter gpu_specter desimodel desitarget specsim desisim fiberassign desisurvey surveysim redrock redrock-templates prospect desimeter simqso speclite specex QuasarNP"
export DESI_SPX_MKL=true
base=$(realpath $DESICONDA/..)
for pkg in $pkgs; do
    # install branches/master and filter bogus error messages
    echo desiInstalling $pkg
    branch=branches/master
    if [ $pkg == "QuasarNP" ] ; then branch="0.1.2"; fi
    if [ $pkg == "desitree" ] ; then branch="0.5.0"; fi
    if [ $pkg ==   "specex" ] ; then branch="0.8.3"; fi
    desiInstall -v -r $base $pkg $branch
done

# remove pip desiutil because we'll use the desiutil module now
pip uninstall desiutil --yes

