pip install --no-binary :all: \
    https://github.com/desihub/speclite/archive/v0.9.tar.gz \
    hpsspy \
    photutils \
    healpy \
    coveralls \
&& pip install \
    cupy-cuda102 \
    line_profiler \
    xlrd \
    configobj
