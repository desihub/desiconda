curl -SL ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-6.2.tar.bz2 \
    -o wcslib-6.2.tar.bz2 \
    && tar xjf wcslib-6.2.tar.bz2 \
    && cd wcslib-6.2 \
    && CC="@CC@" CFLAGS="@CFLAGS@" \
    CPPFLAGS="-I@AUX_PREFIX@/include" \
    LDFLAGS="-L@AUX_PREFIX@/lib" \
    ./configure @CROSS@ \
    --disable-fortran \
    --with-cfitsiolib="@AUX_PREFIX@/lib" \
    --with-cfitsioinc="@AUX_PREFIX@/include" \
    --prefix="@AUX_PREFIX@" \
    && make -j 4 && make install \
    && cd .. \
    && rm -rf wcslib*
