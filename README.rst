=========
desiconda
=========

Introduction
------------

This package contains scripts for installing conda and all compiled
dependencies needed by the spectroscopic pipeline.

Quick start installation
------------------------

To install desiconda and load module::

    # set target
    prefix=/global/common/software/desi/users/${USER}/desiconda
    mkdir -p ${prefix}

    local_copy=/global/cfs/cdirs/desi/users/${USER}/desiconda
    git clone https://github.com/desihub/desiconda ${local_copy}
    cd ${local_copy}

    unset PYTHONPATH
    export DCONDAVERSION=$(date '+%Y%m%d')-2.0.1.dev
    PREFIX=${prefix} ./install.sh |& tee install.log
    module use ${prefix}/${DCONDAVERSION}/modulefiles
    module load desiconda

Then install a suite of desispec, desiutil, etc. modules::

    source scripts/bootstrap-desi.sh

Example
-------

Imagine you wanted to install a set of dependencies for DESI software on a
cluster (rather than manually getting all the dependencies in place).
You plan on installing desiconda in your home directory (``${HOME}/software/desi``)
and you want to have the custom string "my-desiconda" associated with your
installation.

You git-cloned desiconda using::

    git clone https://github.com/desihub/desiconda /path-to-git-clone/desiconda

You also put all the commands for dependencies you want to install and
customizations in the "conf/mypkgs-pkgs.sh" and "conf/myenv-env.sh" files
you created (based on the existing
conf/default-pkgs.sh and conf/nersc-env.sh), respectively.

This install.sh script, in the top-level directory, will create the environment
and install the dependencies and module files. When you run this script, it
will download many MB of binary and source packages, extract files, and compile things.  It will do this in your current working directory.
Also the output will be very long, so pipe it to a log file::

    $> DCONDAVERSION=my-desiconda PREFIX=$HOME/software/desi CONF=myenv PKGS=mypkgs /path-to-git-clone/desiconda2/install.sh 2>&1 | tee log

If everything worked, then you can see your new desiconda install with::

    $> module use $HOME/software/desi/desiconda/$dcondaversion/modulefiles
    $> module avail desiconda

And you can load it with::

    $> module load desiconda/$dcondaversion

Configuration
-------------

If environment and package files (``conf/[envtag]-env.sh`` and ``conf/[pkgtag]-pkgs.sh``) for
your use case already exists in the "conf" directory, then
just use them.  Otherwise, create or edit files in the "conf" subdirectory that
are named after the environment and set of packages you wish to create and install.
See existing files ``conf/default-env.sh`` and ``conf/default-pkgs.sh ``for spectroscopic
pipeline dependencies on cori.

For ``${NERSC_HOST} == "datatran"`` installs use::

    PREFIX=${prefix} PKGS=datatran install.sh

as in the example above.

Contents of installation
------------------------

The installation directory (assuming the installation script was called with
``${DCONDAVERSION}`` and ``${PREFIX}``) will contain directories and files::

    ${PREFIX}/desiconda/${DCONDAVERSION}/conda
    ${PREFIX}/desiconda/${DCONDAVERSION}/aux
    ${PREFIX}/desiconda/${DCONDAVERSION}/modulefiles/desiconda/$DCONDAVERSION
    ${PREFIX}/desiconda/${DCONDAVERSION}/modulefiles/desiconda/.version_$DCONDAVERSION
