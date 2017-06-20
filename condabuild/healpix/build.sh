#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
    CC=clang \
    CXX=clang++ \
    CPPFLAGS="-I${PREFIX}/include" \
    CXXFLAGS="${CXXFLAGS} -O3" \
    LDFLAGS="-L${PREFIX}/lib" \
    ./configure \
    --prefix="${PREFIX}" \
    --disable-mpi \
    --disable-fortran \
    --with-cfitsio="${PREFIX}"
else
    CC=gcc \
    CXX=g++ \
    CPPFLAGS="-I${PREFIX}/include" \
    CXXFLAGS="${CXXFLAGS} -O3" \
    CFLAGS="${CFLAGS} -std=c99" \
    LDFLAGS="-L${PREFIX}/lib" \
    ./configure \
    --prefix="${PREFIX}" \
    --disable-mpi \
    --disable-fortran \
    --with-cfitsio="${PREFIX}"
fi

make
make install
rm -f "${PREFIX}/lib/*.la"

