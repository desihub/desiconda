curl -SL https://github.com/GalSim-developers/GalSim/archive/v1.4.3.tar.gz \
    -o GalSim-1.4.3.tar.gz \
    && tar xzf GalSim-1.4.3.tar.gz \
    && cd GalSim-1.4.3 \
    && scons PREFIX="@AUX_PREFIX@" \
    CXX="@CXX@" FLAGS="@CXXFLAGS@ -std=c++98" \
    TMV_DIR="@AUX_PREFIX@" \
    FFTW_DIR="@AUX_PREFIX@" \
    BOOST_DIR="@AUX_PREFIX@" \
    TMV_DIR="@AUX_PREFIX@" \
    PYTHON="@CONDA_PREFIX@/bin/python" \
    EXTRA_INCLUDE_PATH="@AUX_PREFIX@/include" \
    EXTRA_LIB_PATH="@AUX_PREFIX@/lib" \
    && scons PREFIX="@AUX_PREFIX@" install \
    && cd .. \
    && rm -rf GalSim*

