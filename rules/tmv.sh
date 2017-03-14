curl -SL https://github.com/rmjarvis/tmv/archive/v0.74.tar.gz \
    -o tmv-0.74.tar.gz \
    && tar xzf tmv-0.74.tar.gz \
    && cd tmv-0.74 \
    scons PREFIX="@AUX_PREFIX@" \
    CXX="@CXX@" FLAGS="@CXXFLAGS@" \
    LIBS="" FORCE_MKL=true \


    && CC="@CC@" CFLAGS="@CFLAGS@" ./configure @CROSS@ --prefix=@AUX_PREFIX@ \
    && make -j 4 && make shared && make install \
    && cd .. \
    && rm -rf tmv*

https://github.com/rmjarvis/tmv/archive/v0.74.tar.gz
