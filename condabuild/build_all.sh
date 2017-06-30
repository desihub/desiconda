#!/bin/bash

for pkg in cfitsio speclite fitsio fftw healpix boost harp; do
	conda build ${pkg}
done

