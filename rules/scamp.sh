curl -SL http://www.astromatic.net/download/scamp/scamp-2.0.4.tar.gz \
    -o scamp-2.0.4.tar.gz \
    && tar xzf scamp-2.0.4.tar.gz \
    && cd scamp-2.0.4 \
    && patch -p1 < ../rules/patch_scamp \
    && aclocal \
    && libtoolize --force \
    && automake --add-missing \
    && autoreconf \
    && export blasinc=$(if [ x"@BLAS_INCLUDE@" = x ]; then echo ""; else echo "-I@BLAS_INCLUDE@"; fi) \
    && CC="@CC@" CFLAGS="@CFLAGS@" CPPFLAGS="${blasinc}" ./configure @CROSS@ \
    --with-lapacke="@LAPACK@ @BLAS@" --prefix="@AUX_PREFIX@" \
    && make && make install \
    && cd .. \
    && rm -rf scamp*
