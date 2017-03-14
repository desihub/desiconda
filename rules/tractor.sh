curl -SL http://astrometry.net/downloads/astrometry.net-0.69.tar.gz \
    -o astrometry.net-0.69.tar.gz \
    && tar xzf astrometry.net-0.69.tar.gz \
    && cd astrometry.net-0.69 \
    && CC="@CC@" CXX="@CXX@" CFLAGS="@CFLAGS@" CXXFLAGS="@CXXFLAGS@" make \
    && CC="@CC@" CXX="@CXX@" CFLAGS="@CFLAGS@" CXXFLAGS="@CXXFLAGS@" make -C util py \
    && CC="@CC@" CXX="@CXX@" CFLAGS="@CFLAGS@" CXXFLAGS="@CXXFLAGS@" make -C libkd py \
    && make install INSTALL_DIR=@AUX_PREFIX@ \
    && cd .. \
    && rm -rf astrometry*
