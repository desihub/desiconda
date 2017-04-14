#!/bin/bash

# This is just a helper script to generate install
# scripts for a NERSC machine.

ver="$1"

mach="${NERSC_HOST}"

specconfs=""
survconfs=""
if [ "${mach}" = "edison" ]; then
    specconfs="gcc"
    survconfs="gcc-py27"
elif [ "${mach}" = "cori" ]; then
    specconfs="gcc haswell-intel knl-intel"
    survconfs="gcc-py27"
fi

# install and module prefix

inst="/global/common/${mach}/contrib/desi/code"
moddir="/global/common/${mach}/contrib/desi/modulefiles"

for conf in ${survconfs}; do
    CONFIG="${mach}-${conf}" PREFIX="${inst}" VERSION="${ver}-imaging" \
    MODULEDIR="${moddir}" make imaging
done

for conf in ${specconfs}; do
    CONFIG="${mach}-${conf}" PREFIX="${inst}" VERSION="${ver}-spectro" \
    MODULEDIR="${moddir}" make spectro
done
