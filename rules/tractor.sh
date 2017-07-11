curl -SL https://github.com/dstndstn/tractor/archive/dr5.1.tar.gz \
    -o tractor-dr5.1.tar.gz \
    && tar xzf tractor-dr5.1.tar.gz \
    && cd tractor-dr5.1 \
    && python setup.py install --with-ceres --prefix="@AUX_PREFIX@" \
    && cd .. \
    && rm -rf tractor*
