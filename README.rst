===========
desiconda
===========

Introduction
---------------

This package contains scripts for installing conda and all compiled
dependencies needed by the spectroscopic pipeline.  The rules to install
or build each dependency is separated into a file, and used by both
regular installs and building docker images.


Configuration
----------------

Create or edit a file in the "conf" subdirectory that is named after the 
system you are building on.  This file will define compilers, flags, etc.
Optionally create files with the same name and the ".module" and ".sh"
suffixes.  These optional files should contain any modulefile and shell 
commands needed to set up the environment.  See existing files for 
examples.

To create a config for a docker image, the config file must be prefixed
with "docker-".


Generate the Script
-----------------------

Set the CONFIG, PREFIX, and (optionally) VERSION environment variables.
Then create the script with::

    $> make script

To clean up all generated scripts, do::

    $> make clean

For normal installs, this creates an install script and corresponding
module files.  For docker builds, a Dockerfile is created.


Installation
------------

For normal installs, simply run the install script.  This installs the
software and modulefile, as well as a module version file named
".version_$VERSION" in the module install directory.  You can manually
move this into place if and when you want to make that the default
version.

For docker installs, run docker build from the same directory as the
generated Dockerfile, so that the path to data files can be found.


License
-------

desiconda is free software licensed under a 3-clause BSD-style license. For details see
the ``LICENSE.rst`` file.
