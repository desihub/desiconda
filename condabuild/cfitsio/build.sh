#!/bin/bash

eval ./configure --prefix="${PREFIX}"
make
make shared
make install
rm -f "${PREFIX}/lib/*.la"
