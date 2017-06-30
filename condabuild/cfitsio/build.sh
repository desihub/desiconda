#!/bin/bash

eval ./configure --prefix="${PREFIX}"
make
make shared
make fpack
make funpack
make install
rm -f "${PREFIX}/lib/*.la"

