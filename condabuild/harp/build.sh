#!/bin/bash

eval \
CPPFLAGS="-I${PREFIX}/include" \
LDFLAGS="-L${PREFIX}/lib" \
./configure \
--prefix="${PREFIX}" \
--disable-python \
--disable-mpi \
--with-cfitsio="${PREFIX}" \
--with-boost="${PREFIX}" \
--with-blas="\"-lmkl_rt -fopenmp -lpthread -lm -ldl\""
make
make install
rm -f "${PREFIX}/lib/*.la"

