#!/bin/bash

# Bootstrap installation of the main branch of a set of DESI modules

if [ -z "$DESICONDA" ] || [ -z "$DESICONDA_VERSION" ]; then
    echo "Load a desiconda module first to get \$DESICONDA and $DESICONDA_VERSION"
    return
fi

iskpno=false
if [[ "$HOSTNAME" == "desi-7" ]] || [[ "$HOSTNAME" == "desi-8" ]]; then
    if [ "$USER" == "datasystems" ]; then
        iskpno=true
    else
        echo "At KPNO, must run as datasystems."
        return
    fi
fi

usage() { echo "Usage: $0 [-h] [-c filename.ini] [-v]" 1>&2; exit 1; }

while getopts "h:v:c:" opt; do
    case ${opt} in
        v)
           set -x # print commands as they are run
           ;;
        c)
           configfile=${OPTARG}
           ;;
        h | *)
           usage
           ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$configfile" ]]; then
  usage
fi

# Install desiutil to get desiInstall script
# (will remove this later after installing the desiutil module)
# Note that special instructions are needed at KPNO (desi-8).
if [ $iskpno == true ]; then
    ssh git@desi-general git -C desiutil fetch
#    git clone git@desi-general:desiutil desiutil-installer

    #- Temporary: use kpno-projects-update branch
    git clone git@desi-general:desiutil -c advice.detachedHead=false --branch=kpno-projects-update desiutil-installer

#    #- For old installations (godesi 23.10) use desiutil 3.4.1
#    git clone git@desi-general:desiutil -c advice.detachedHead=false --branch=3.4.1 desiutil-installer
#    pushd  desiutil-installer
#    git apply ../desiutil-3.4.1.patch
#    popd

    echo "export PATH=`pwd`/desiutil-installer/bin:\$PATH" > env.txt
    echo "export PYTHONPATH=`pwd`/desiutil-installer/py:\$PYTHONPATH" >> env.txt
    source env.txt
    rm env.txt
else
     pip install git+https://github.com/desihub/desiutil.git
fi

# Set up the environment and loop through packages specified in the config
# file, installing one-by-one
export DESI_SPX_MKL=true
base=$(realpath ${DESICONDA}/..)

while IFS= read line <&3; do
    # Remove leading/trailing whitespace
    line=$(echo -e "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    # Skip empty lines and comments
    if [[ -z "$line" || "$line" == "#"* ]]; then
        continue
    fi

    # Check for section headers; reset package name + version
    if [[ "$line" == "[package]"* ]]; then
        name=""
        version=""
        continue
    fi

    # Extract package name, url, and version
    if [[ "$line" == "name"*"="* ]]; then
        name=$(echo "$line" | cut -d'=' -f2 | awk '{$1=$1};1')
    fi

    if [[ "$line" == "url"*"="* ]]; then
        url=$(echo "$line" | cut -d'=' -f2 | awk '{$1=$1};1')
        echo $url
    fi

    if [[ "$line" == "version"*"="* ]]; then
        version=$(echo "$line" | cut -d'=' -f2 | awk '{$1=$1};1')
    fi

    # Install a package name + version
    if [[ -n "$name" ]] && [[ -n "$url" ]] && [[ -n "$version" ]]; then
        echo "Installing package ${name}: version ${version}"
        echo "desiInstall -v -p $name:$url -r $base $name $version"
        desiInstall -v -p $name:$url -r $base $name $version

        # Special case to compile specex/main and fiberassign/main
        if [[ "$name" == "specex" ]] && [[ "$version" == "main" ]]; then
            module load specex/main
            pushd $SPECEX
            python setup.py build_ext --inplace
            popd
        fi

        if [[ "$name" == "fiberassign" ]] && [[ "$version" == "main" ]]; then
            module load fiberassign/main
            pushd $FIBERASSIGN
            python setup.py build_ext --inplace
            popd
        fi

        echo "Done setting up $name"
        echo ""
    fi
done 3< "$configfile"

# Clean up
if [ $iskpno == true ]; then
    rm -rf desiutil-installer
else
    # install dust module from an earlier version of desiconda
    pushd $PREFIX
    cp -r 20230111-2.1.0/modulefiles/dust $DCONDAVERSION/modulefiles/
    popd

    # remove pip desiutil because we'll use the desiutil module now
    pip uninstall desiutil --yes
fi
