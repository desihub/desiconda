curl -SL https://github.com/dstndstn/tractor/archive/dr5.2.tar.gz \
    -o tractor-dr5.2.tar.gz \
    && tar xzf tractor-dr5.2.tar.gz \
    && cd tractor-dr5.2 \
    && CERES_LIB="-L@AUX_PREFIX@/lib -lceres" \
    python setup.py install --with-ceres --prefix="@AUX_PREFIX@" \
    && cd .. \
    && rm -rf tractor*
