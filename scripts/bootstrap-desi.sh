#!/bin/bash

# Bootstrap installation of the main branch of a set of DESI modules

if [[ -z "$DESICONDA" || -z "$DESICONDA_VERSION" ]]; then
    echo "ERROR: Load a desiconda module first to get \$DESICONDA and \$DESICONDA_VERSION" >&2
    return
fi

# KPNO-specific installation interface:
if [[ "$HOSTNAME" == "desi-7" ]] || [[ "$HOSTNAME" == "desi-8" ]]; then
    if [ "$USER" != "datasystems" ]; then
        echo "At KPNO, must run as datasystems."
        exit 1
    fi

    usage() { echo "Usage: ${0} [-h] [-v] [-c filename.ini]" 1>&2; exit 1; }

    while getopts "hvc:" opt; do
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

    # Check for an INI file with a list of packages to install
    if [[ -z "$configfile" ]]; then
      usage
    fi

    # Grab desiutil (temporary: use the kpno-projects-update branch)
    ssh git@desi-general git -C desiutil fetch

    #- Temporary: use kpno-projects-update branch
    git clone git@desi-general:desiutil -c advice.detachedHead=false --branch=kpno-projects-update desiutil-installer

    echo "export PATH=`pwd`/desiutil-installer/bin:\$PATH" > env.txt
    echo "export PYTHONPATH=`pwd`/desiutil-installer/py:\$PYTHONPATH" >> env.txt
    source env.txt
    rm env.txt

    # Set up the environment and loop through packages in the INI file
    export DESI_SPX_MKL=true
    base=$(realpath $DESICONDA/..)

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
    rm -rf desiutil-installer

    # install dust module from an earlier version of desiconda
    pushd $PREFIX
    cp -r kpno-20250320-2.2.1.dev/modulefiles/dust $DCONDAVERSION/modulefiles/
    popd

# Installation outside of KPNO
else
    # Install desiutil to get desiInstall script
    # (will remove this later after installing the desiutil module)
    pip install desiutil

    if [[ "${NERSC_HOST}" == "datatran" ]]; then
        # NERSC Data Transfer Nodes have minimal environment
        pkgs="desiutil desitree desiBackup desidatamodel desitransfer desida"
        # MODULESHOME may be incorrectly set on datatran.
        if [[ -z "${MODULESHOME}" || ! -d ${MODULESHOME} ]]; then
            if [[ -d /usr/share/lmod/lmod ]]; then
                export MODULESHOME=/usr/share/lmod/lmod
            else
                echo "ERROR: Could not determine the MODULESHOME directory!" >&2
                return
            fi
        fi
    else
        # Default is everything
        pkgs="desiutil desitree desispec specter gpu_specter desimodel desitarget specsim desisim fiberassign desisurvey surveysim redrock redrock-templates prospect desimeter simqso speclite specex QuasarNP desisim-testdata desisurveyops specprod-db fastspecfit gfa_reduce desiBackup desida desidatamodel"
    fi

    export DESI_SPX_MKL=true
    base=$(realpath $DESICONDA/..)
    for pkg in $pkgs; do
        # install branches/main
        echo "INFO: desiInstalling $pkg"
        branch=branches/main

        # some packages we special-case to tagged versions
        if [[ $pkg == "QuasarNP" ]] ; then branch="0.2.0"; fi
        if [[ $pkg == "desitree" ]] ; then branch="0.7.0"; fi
        ### if [[ $pkg == "specex" ]] ; then branch="0.8.6"; fi

        echo "INFO: desiInstall -v -r $base $pkg $branch"
        desiInstall -v -r $base $pkg $branch

        # special case to compile specex and fiberassign main
        if [[ $pkg == "specex" ]]; then
            module load specex/main
            pushd $SPECEX
            python setup.py build_ext --inplace
            popd
        fi

        if [[ $pkg == "fiberassign" ]]; then
            module load fiberassign/main
            pushd $FIBERASSIGN
            python setup.py build_ext --inplace
            popd
        fi
    done

    # remove pip desiutil because we'll use the desiutil module now
    pip uninstall desiutil --yes
fi
