#!/bin/bash

# Manually build the extension against our cfitsio

eval ${PYTHON} setup.py build_ext \
    --use-system-fitsio \
    --system-fitsio-includedir="${PREFIX}/include" \
    --system-fitsio-libdir="${PREFIX}/lib"

# Manually copy the normal python files into place

sitever=$(${PYTHON} --version 2>&1 | awk '{print $2}' | sed -e "s#\(.*\..*\)\..*#\1#")

mkdir -p "${PREFIX}/lib/python${sitever}/fitsio"

ext=$(ls ${SRC_DIR}/build/lib.*/fitsio/*)
pyfiles=$(ls ${SRC_DIR}/fitsio/*.py)

cp -a ${ext} ${pyfiles} "${PREFIX}/lib/python${sitever}/fitsio/"

