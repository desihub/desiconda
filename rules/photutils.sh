curl -SL https://pypi.python.org/packages/0d/c4/fca2906c5cf10547743357c813ab051419a9aeb383e14baaf7b7eee3f89a/photutils-0.3.2.tar.gz#md5=7811873224b22c6ff8fef732e1d93daa \
    -o photutils-0.3.2.tar.gz \
    && tar xzf photutils-0.3.2.tar.gz \
    && cd photutils-0.3.2 \
    && python setup.py install --prefix=@AUX_PREFIX@ \
    && cd .. \
    && rm -rf photutils* \
