===========
desiconda
===========

Introduction
---------------

This package contains scripts for installing conda and all compiled
dependencies needed by the spectroscopic pipeline and the imaging survey.
The rules to install or build each dependency is separated into a file
and used by both regular installs and for building docker images.


Examples
----------------

In case you don't have time to read the details below, here are a couple
of concrete examples to start.


Example 1:  Spectro Pipeline on a Workstation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Imagine you wanted to install a full desiconda stack to a workstation or
cluster (rather than manually getting all the dependencies in place).  
You followed the section below and created a config file for you machine
called "myserver" and put it in the conf directory.  You plan on installing
desiconda in your home directory (~/software/desi).  Since you downloaded
the latest tagged version (1.1.3) of desiconda, you are happy with the 
automatic version string that will be used for the install prefix.  The 
spectro pipeline primarily works with python3, so that is what you specified 
in your "myserver" config.

First, clean up any stale install scripts::

    $> CONFIG=myserver PREFIX=$HOME/software/desi make clean

Now generate the script::

    $> CONFIG=myserver PREFIX=$HOME/software/desi make spectro

This creates an install script and some extra files in the top directory.  When
you run this script, it will download many MB of binary and source packages, 
extract files, and compile things.  It will do this in your current working
directory.  Also the output will be very long, so pipe it to a log file::

    $> ~/desiconda/install_imaging_myserver.sh 2>&1 | tee log

After this runs, the script should clean up after itself and the only file 
remaining should be the log file.  If other files exist, then something went
wrong.  Look in the log file to find the first package that failed to build.
All packages after that point may or may not have completed.

If everything worked, then you can see your new desiconda install with::

    $> module use $HOME/software/desi/modulefiles
    $> module avail desiconda

And you can load it with::

    $> module load desiconda

The install also creates a "version" file that can be used to set the default
version of the desiconda module.  In this example you could make version 
1.1.3 the default with::

    $> cd $HOME/software/desi/modulefiles/desiconda
    $> rm -f .version; ln -s .version_1.1.3 .version


Example 2:  Imaging Dependencies at NERSC
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Let's say that you are working on the DESI imaging data and want to install
everything to your scratch space so that you have complete control.

The imaging survey still uses python2.7, so you should use either the 
"cori-gcc-py27" or "edison-gcc-py27" configuration profiles.  Pick an install
location (probably on $SCRATCH).  For this example, we choose $SCRATCH/software
and will be running on edison.  Choose a version string to use (say "20170511").

Clean up::

    $> CONFIG=edison-gcc-py27 PREFIX=$SCRATCH/software \
       VERSION=20170511 make clean

Now generate the script::

    $> CONFIG=edison-gcc-py27 PREFIX=$SCRATCH/software \
       VERSION=20170511 make imaging

This creates an install script and some extra files in the top directory.  When
you run this script, it will download many MB of binary and source packages, 
extract files, and compile things.  It will do this in your current working
directory.

Where is the desiconda checkout containing this README file?  If it is in 
scratch, then you can run the generated install script from this very directory.
If your git checkout of desiconda is in $HOME or someplace else, then do the
actual building in $SCRATCH::

    $> cd $SCRATCH
    $> mkdir build
    $> cd build

Also the output will be very long, so pipe it to a log file::

    $> ~/desiconda/install_imaging_edison-gcc-py27.sh 2>&1 | tee log

After this runs, the script should clean up after itself and the only file 
remaining should be the log file.  If other files exist, then something went
wrong.  Look in the log file to find the first package that failed to build.
All packages after that point may or may not have completed.

If everything worked, then you can see your new desiconda install with::

    $> module use $SCRATCH/software/modulefiles
    $> module avail desiconda

And you can load it with::

    $> module load desiconda/20170511

The install also creates a "version" file that can be used to set the default
version of the desiconda module.  In this example you could make version 
20170511 the default with::

    $> cd $SCRATCH/software/modulefiles/desiconda
    $> rm -f .version; ln -s .version_20170511 .version


The Details
----------------

Now that you have seen a couple of examples, here are the details.

Configuration
~~~~~~~~~~~~~~~~~~

If a config file for your use case already exists in the "conf" directory, then
just use it.  Otherwise, create or edit a file in the "conf" subdirectory that 
is named after the system you are building on.  This file will define 
compilers, flags, etc.  Optionally create files with the same name and the 
".module" and ".sh" suffixes.  These optional files should contain any 
modulefile and shell commands needed to set up the environment.  See existing 
files for examples.

To create a config for a docker image, the config file must be prefixed
with "docker-".  You should not have any "*.module" or "*.sh" files for
a docker config.

Some imaging survey software (tractor) requires python2.  If you installing
the imaging target, then you must use a config that is python2 based.


Generate the Script
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Set the CONFIG, PREFIX, and (optionally) the VERSION and MODULEDIR 
environment variables.  Then create the install script with::

    $> make spectro

OR::

    $> make imaging

To clean up all generated scripts, do::

    $> make clean

For normal installs, this creates an install script and corresponding
module files.  For docker builds, a Dockerfile is created.  As an example,
suppose we are installing a desiconda stack into our scratch directory
on edison using the gcc config::

    $> PREFIX=${SCRATCH}/software/desi CONFIG=edison-gcc make clean
    $> PREFIX=${SCRATCH}/software/desi CONFIG=edison-gcc make spectro

If you don't have the $VERSION environment variable set, then a version
string based on the git revision history is used.  If you don't have the
$MODULEDIR environment variable set, then the modulefiles will be installed
to $PREFIX/modulefiles.


Installation
~~~~~~~~~~~~~~~~~~~~~~~~

For normal installs, simply run the install script.  This installs the
software and modulefile, as well as a module version file named
".version_$VERSION" in the module install directory.  You can manually
move this into place or symlink it if and when you want to make that the 
default version.  You can run the install script from an alternate build 
directory.  

For docker installs, run "docker build" from the same directory as the 
generated Dockerfile, so that the path to data files can be found.  Making 
docker images requires a working docker installation and also an Intel 
based processor if you are building an image that uses Intel python packages.
You should familiarize yourself with the docker tool before attempting to use
it for desiconda.

As an example, suppose we want to install the script we made in the
previous section for edison.  We'll make a temporary directory on
scratch to do the building, since it is going to download and compile
several big packages.  We'll also dump all output to a log file so that
we can look at it afterwards if there are any problems::

    $> cd $SCRATCH
    $> mkdir build
    $> cd build
    $> /path/to/git/desiconda/install_spectro_edison-gcc.sh >log 2>&1 &
    $> tail -f log

After installation, the $PREFIX directory will contain directories
and files::

    $PREFIX/desiconda/$VERSION_conda
    $PREFIX/desiconda/$VERSION_aux
    $PREFIX/modulefiles/desiconda/$VERSION
    $PREFIX/modulefiles/desiconda/.version_$VERSION

If you want to make this version of desiconda the default, then just
do::

    $> ln -s .version_$VERSION .version


License
-------

desiconda is free software licensed under a 3-clause BSD-style license. For
details see the ``LICENSE.rst`` file.
