#!/bin/bash

for pkg in fitsio speclite cfitsio fftw healpix boost harp; do
	conda build ${pkg}
done

