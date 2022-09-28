====================
desiconda Change Log
====================

2.1.0 (2022-09-28)
------------------

* Update configuration for ``datatran`` nodes; other version updates (PR `#57`_).

.. _`#57`: https://github.com/desihub/desiconda/pull/57

2.0.1 (2022-01-19)
------------------

* Installs successfully on Perlmutter with the same commands as on Cori (PR `#47`_).

.. _`#47`: https://github.com/desihub/desiconda/pull/47

2.0.0 (2022-01-10)
------------------

In use at NERSC since 2021-12-17 though the tag didn't happen until 2022-01-10.

* Major refactor to remove boost and other compiled 3rd party dependencies (PR `#45`_).

.. _`#45`: https://github.com/desihub/desiconda/pull/45

1.4.0 (2020-08-07)
------------------

Used for ``20200801-1.4.0-spec`` installation, but not tagged until Aug 7:

* Upgrade to python 3.8, astropy 4.x, fitsio 1.x, bokeh 2.x;
  Add iminuit, pycuda, papermill, dask-distributed, and sphinx (PR `#40`_).

.. _`#40`: https://github.com/desihub/desiconda/pull/40

1.3.0 (2019-09-20)
------------------

Used to install ``desiconda/20190804-1.3.0-spec`` at NERSC and tagged post-facto.

* Pin ``pytest`` version for compatibility with ``specsim``+``astropy`` tests.
* Pin ``matplotlib`` version (I don't recall exactly why, but it was
  purposeful to work around some problem uncovered in testing).
* Added ``dask`` and distributed conda packages for R&D / exploratory work.
* Adds progress messages with timestamps during installation as part of the installed modulefile:

  - sets ``$DESICONDA_VERSION``(for convenience; previously this was available
    by parsing directory paths in ``$DESICONDA`` and ``$DESICONDA_EXTRA``, but not
    as an environment variable with just the version.
  - sets ``$PROJ_LIB`` (needed by basemap).

1.2.7 and prior
---------------

See `release notes on GitHub`_.

.. _`release notes on GitHub`: https://github.com/desihub/desiconda/releases
