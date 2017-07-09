curl -SL https://www.dropbox.com/s/pzps5m45mnmv6ap/mkl_2017.0.3_include.tar.gz?dl=1 \
    -o mkl_2017.0.3_include.tar.gz \
    && tar xzf mkl_2017.0.3_include.tar.gz -C @AUX_PREFIX@/include --strip=1 \
    && rm mkl_2017.0.3_include.tar.gz \
    && if [ "@AUX_PREFIX@" != "@CONDA_PREFIX@" ]; then \
	for lb in $(ls @CONDA_PREFIX@/lib/libmkl*); do \
	    lbname=$(basename ${lb}); \
	    linkpath="@AUX_PREFIX@/lib/${lbname}"; \
	    if [ ! -e ${linkpath} ]; then \
	        ln -s "${lb}" "${linkpath}"; \
	    fi; \
	done; \
    fi
