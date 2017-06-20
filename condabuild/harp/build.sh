#!/bin/bash


if [ "$(uname)" == "Darwin" ]; then
    CC=clang \
    CXX=clang++ \
    CPPFLAGS="-I${PREFIX}/include" \
    CXXFLAGS="${CXXFLAGS} -O3 -std=c++11 -stdlib=libc++" \
    LDFLAGS="-L${PREFIX}/lib -stdlib=libc++" \
    ./configure \
    --prefix="${PREFIX}" \
    --disable-mpi \
    --disable-python \
    --with-cfitsio="${PREFIX}" \
    --with-boost="${PREFIX}" \
    --with-blas="-lmkl_rt"
else
    CC=gcc \
    CXX=g++ \
    CPPFLAGS="-I${PREFIX}/include" \
    CXXFLAGS="${CXXFLAGS} -O3 -std=c++11" \
    LDFLAGS="-L${PREFIX}/lib" \
    ./configure \
    --prefix="${PREFIX}" \
    --disable-mpi \
    --disable-python \
    --with-cfitsio="${PREFIX}" \
    --with-boost="${PREFIX}" \
    --with-blas="-lmkl_rt -fopenmp -lpthread -lm -ldl"
fi

make
make install
rm -f "${PREFIX}/lib/*.la"

