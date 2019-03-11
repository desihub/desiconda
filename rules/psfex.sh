curl -SL http://www.astromatic.net/download/psfex/psfex-3.17.1.tar.gz \
    -o psfex-3.17.1.tar.gz \
    && tar xzf psfex-3.17.1.tar.gz \
    && cd psfex-3.17.1 \
    && patch -p1 < ../rules/patch_psfex \
    && aclocal \
    && libtoolize --force \
    && automake --add-missing \
    && autoreconf \
    && export blasinc=$(if [ x"@BLAS_INCLUDE@" = x ]; then echo ""; else echo "-I@BLAS_INCLUDE@"; fi) \
    && CC="@CC@" CFLAGS="@CFLAGS@" CPPFLAGS="${blasinc}" ./configure @CROSS@ \
    --with-lapacke="@LAPACK@ @BLAS@" --prefix="@AUX_PREFIX@" \
    && make && make install \
    && cd .. \
    && rm -rf psfex*
