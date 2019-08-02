curl -SL https://files.pythonhosted.org/packages/55/a2/c827b196070e161357b49287fa46d69f25641930fd5f854722319d431843/mpi4py-3.0.1.tar.gz \
    -o mpi4py-3.0.1.tar.gz \
    && tar xzf mpi4py-3.0.1.tar.gz \
    && cd mpi4py-3.0.1 \
    && echo "[desi]" > mpi.cfg \
    && echo "mpicc = @MPICC@" >> mpi.cfg \
    && echo "mpicxx = @MPICXX@" >> mpi.cfg \
    && echo "include_dirs = @MPI_CPPFLAGS@" >> mpi.cfg \
    && echo "library_dirs = @MPI_LDFLAGS@" >> mpi.cfg \
    && echo "runtime_library_dirs = @MPI_LDFLAGS@" >> mpi.cfg \
    && echo "libraries = @MPI_LIB@" >> mpi.cfg \
    && echo "extra_compile_args = @MPI_EXTRA_COMP@" >> mpi.cfg \
    && echo "extra_link_args = @MPI_EXTRA_LINK@" >> mpi.cfg \
    && python setup.py build --mpi=desi \
    && python setup.py install --prefix="@AUX_PREFIX@" \
    && cd .. \
    && rm -rf mpi4py*
