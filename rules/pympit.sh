git clone https://github.com/tskisner/pympit.git \
    && cd pympit \
    && python setup.py build \
    && python setup.py install --prefix=@AUX_PREFIX@ \
    && cd .. \
    && rm -rf pympit
