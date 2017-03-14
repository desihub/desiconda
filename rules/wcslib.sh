curl -SL ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-5.16.tar.bz2 \
    -o wcslib-5.16.tar.bz2 \
    && tar xjf wcslib-5.16.tar.bz2 \
    && cd wcslib-5.16 \
    && CC="@CC@" CFLAGS="@CFLAGS@" ./configure @CROSS@ \
    --prefix=@AUX_PREFIX@ \
    && make -j 4 && make install \
    && cd .. \
    && rm -rf wcslib*
