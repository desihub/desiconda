curl -SL https://github.com/dstndstn/tractor/archive/dr6.1.tar.gz \
    -o tractor-dr6.1.tar.gz \
    && tar xzf tractor-dr6.1.tar.gz \
    && cd tractor-dr6.1 \
    && CERES_LIB="-L@AUX_PREFIX@/lib -lceres" \
    CC="@CC@" CFLAGS="@CFLAGS@" LDSHARED="@CC@ -shared" \
    python setup.py install --with-ceres --prefix="@AUX_PREFIX@" \
    && cd .. \
    && rm -rf tractor*
