#!/bin/bash

pkglist="\
cfitsio-3.41-0.tar.bz2 \
fftw-3.3.5-0.tar.bz2 \
healpix-3.31.2-0.tar.bz2 \
harp-1.0.2-0.tar.bz2 \
"

for pkg in ${pkglist}; do
	anaconda upload /conda/conda-bld/linux-64/${pkg}
done

