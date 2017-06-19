#!/bin/bash

for pkg in cfitsio fftw healpix harp; do
	conda build ${pkg}
done

