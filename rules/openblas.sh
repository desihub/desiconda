curl -SL https://github.com/xianyi/OpenBLAS/archive/v0.3.7.tar.gz \
    | tar xzf - \
    && cd OpenBLAS-0.3.7 \
    && make USE_OPENMP=1 NO_SHARED=0 \
    FC="@FC@" FCOMMON_OPT="@FCFLAGS@" \
    CC="@CC@" COMMON_OPT="@CFLAGS@" \
    && make NO_SHARED=0 PREFIX="@AUX_PREFIX@" install \
    && cd .. \
    && rm -rf OpenBLAS*
