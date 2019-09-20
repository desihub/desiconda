====================
desiconda change Log
====================

1.3.1 (unreleased)
------------------

* No changes yet

1.3.0 (2019-09-20)
------------------

Used to install desiconda/20190804-1.3.0-spec at NERSC and tagged post-facto

* pin pytest version for compatibility with specsim+astropy tests
* pin matplotlib version (I don't recall exactly why, but it was
  purposeful to work around some problem uncovered in testing)
* added dask and distributed conda packages for R&D / exploratory work
* adds progress messages with timestamps during installation
  as part of the installed modulefile:

  * sets $DESICONDA_VERSION (for convenience; previously this was available
    by parsing directory paths in $DESICONDA and $DESICONDA_EXTRA, but not
    as an environment variable with just the version.
  * sets $PROJ_LIB (needed by basemap)

1.2.7 and prior
---------------

See release notes on github

