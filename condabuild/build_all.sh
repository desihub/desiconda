#!/bin/bash

for pkg in cfitsio fftw healpix boost harp; do
	conda build ${pkg}
done

