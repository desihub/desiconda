#!/bin/bash

pkglist="\
astropy-helpers-1.3.1-0.tar.bz2 \
fitsio-0.9.12rc1-0.tar.bz2 \
speclite-0.5-0.tar.bz2 \
cfitsio-3.41-0.tar.bz2 \
fftw-3.3.5-0.tar.bz2 \
healpix-3.31.2-0.tar.bz2 \
boost-1.61.0-0.tar.bz2 \
harp-1.0.2-0.tar.bz2 \
"

root="$(dirname $(which conda))/.."
plat=$(conda info | grep platform | awk '{print $3}')

for pkg in ${pkglist}; do
    anaconda upload "${root}/conda-bld/${plat}/${pkg}"
done

