curl -SL http://www.astromatic.net/download/sextractor/sextractor-2.19.5.tar.gz \
    -o sextractor-2.19.5.tar.gz \
    && tar xzf sextractor-2.19.5.tar.gz \
    && cd sextractor-2.19.5 \
    && patch -p1 < ../rules/patch_sextractor \
    && aclocal \
    && libtoolize --force \
    && automake --add-missing \
    && autoreconf \
    && export blasinc=$(if [ x"@BLAS_INCLUDE@" = x ]; then echo ""; else echo "-I@BLAS_INCLUDE@"; fi) \
    && CC="@CC@" CFLAGS="@CFLAGS@" CPPFLAGS="${blasinc}" ./configure @CROSS@ \
    --with-lapacke="@LAPACK@ @BLAS@" --prefix="@AUX_PREFIX@" \
    && make && make install \
    && cd .. \
    && rm -rf sextractor*
