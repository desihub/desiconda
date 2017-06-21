#!/bin/bash

eval ${PYTHON} setup.py build
eval ${PYTHON} setup.py install --prefix="${PREFIX}"

