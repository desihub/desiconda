git clone https://bitbucket.org/berkeleylab/qdo.git \
    --depth 1 --branch master --single-branch \
    && cd qdo \
    && python setup.py install --prefix=@AUX_PREFIX@ \
    && cd .. \
    && rm -rf qdo
