#!/bin/bash

eval ./configure --prefix="${PREFIX}" --disable-python --disable-mpi
make
make install
rm -f "${PREFIX}/lib/*.la"

