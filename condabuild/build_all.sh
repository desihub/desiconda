#!/bin/bash

for pkg in astropy-helpers fitsio speclite cfitsio fftw healpix boost harp; do
	conda build ${pkg}
done

