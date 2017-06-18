#!/bin/bash

eval ./configure \
--prefix="${PREFIX}" \
--disable-mpi \
--disable-fortran
make
make install
rm -f "${PREFIX}/lib/*.la"

