#!/bin/bash

conda create -n build --clone="/conda"
source activate build

conda index ~/conda-bld


