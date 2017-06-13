#!/bin/bash

eval ./configure --enable-threads --prefix="${PREFIX}"
make
make install
rm -f "${PREFIX}/lib/*.la"
