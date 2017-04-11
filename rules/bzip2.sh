curl -SL http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz \
    -o bzip2-1.0.6.tar.gz \
    && tar xzf bzip2-1.0.6.tar.gz \
    && cd bzip2-1.0.6 \
    && make CC="@CC@" CFLAGS="@CFLAGS@" PREFIX="@AUX_PREFIX@" \
    && make CC="@CC@" CFLAGS="@CFLAGS@" PREFIX="@AUX_PREFIX@" install \
    && cd .. \
    && rm -rf bzip2*
