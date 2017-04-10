curl -SL @MINICONDA@ \
    -o miniconda.sh \
    && /bin/bash miniconda.sh -b -f -p @CONDA_PREFIX@ \
    && conda install --copy --yes python=@PYVERSION@ \
    && rm miniconda.sh \
    && rm -rf @CONDA_PREFIX@/pkgs/*
