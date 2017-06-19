#!/bin/bash

eval CFLAGS="-std=c99 ${CFLAGS}" \
./configure \
--prefix="${PREFIX}" \
--disable-mpi \
--disable-fortran \
--with-cfitsio="${PREFIX}"
make
make install
rm -f "${PREFIX}/lib/*.la"

