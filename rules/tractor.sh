curl -SL https://github.com/dstndstn/tractor/archive/dr5.0.tar.gz \
    -o tractor-dr5.0.tar.gz \
    && tar xzf tractor-dr5.0.tar.gz \
    && cd tractor-dr5.0 \
    && CC="@CC@" CXX="@CXX@" CFLAGS="@CFLAGS@" CXXFLAGS="@CXXFLAGS@" make \
    SUITESPARSE_LIB_DIR="@AUX_PREFIX@/lib" BLAS_LIB="@BLAS@" \
    PKG_CONFIG_PATH="@AUX_PREFIX@/share/pkgconfig" \
    && make install INSTALL_DIR=@AUX_PREFIX@ \
    && cd .. \
    && rm -rf tractor*
