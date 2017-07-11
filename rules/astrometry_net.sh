curl -SL https://github.com/dstndstn/astrometry.net/releases/download/0.72/astrometry.net-0.72.tar.gz \
    -o astrometry.net-0.72.tar.gz \
    && tar xzf astrometry.net-0.72.tar.gz \
    && cd astrometry.net-0.72 \
    && CC="@CC@" CXX="@CXX@" CFLAGS="@CFLAGS@" CXXFLAGS="@CXXFLAGS@" \
    LDFLAGS="-L@AUX_PREFIX@/lib -lz" make \
    WCSLIB_INC="-I@AUX_PREFIX@/include/wcslib" WCSLIB_LIB="-L@AUX_PREFIX@/lib -lwcs" \
    JPEG_INC="-I@AUX_PREFIX@/include" JPEG_LIB="-L@AUX_PREFIX@/lib -ljpeg" \
    CFITS_INC="-I@AUX_PREFIX@/include" CFITS_LIB="-L@AUX_PREFIX@/lib -lcfitsio -lm" \
    && CC="@CC@" CXX="@CXX@" CFLAGS="@CFLAGS@" CXXFLAGS="@CXXFLAGS@" \
    LDFLAGS="-L@AUX_PREFIX@/lib -lz" make \
    WCSLIB_INC="-I@AUX_PREFIX@/include/wcslib" WCSLIB_LIB="-L@AUX_PREFIX@/lib -lwcs" \
    JPEG_INC="-I@AUX_PREFIX@/include" JPEG_LIB="-L@AUX_PREFIX@/lib -ljpeg" \
    CFITS_INC="-I@AUX_PREFIX@/include" CFITS_LIB="-L@AUX_PREFIX@/lib -lcfitsio -lm" \
    extra \
    && make install INSTALL_DIR="@AUX_PREFIX@" \
    && cd .. \
    && rm -rf astrometry*
