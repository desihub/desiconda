loaded=`${MODULESHOME}/bin/modulecmd sh -t list 2>&1 | grep PrgEnv-"$CONDAPRGENV"`

loadedgnu=`${MODULESHOME}/bin/modulecmd sh -t list 2>&1 | grep PrgEnv-gnu`
loadedintel=`${MODULESHOME}/bin/modulecmd sh -t list 2>&1 | grep PrgEnv-intel`
loadedcray=`${MODULESHOME}/bin/modulecmd sh -t list 2>&1 | grep PrgEnv-cray`

if [ "x${loaded}" = x ]; then
    if [ "x${loadedcray}"  != x ]; then
      module swap PrgEnv-cray  PrgEnv-$CONDAPRGENV
    fi
    if [ "x${loadedintel}" != x ]; then
      module swap PrgEnv-intel PrgEnv-$CONDAPRGENV
    fi
    if [ "x${loadedgnu}"   != x ]; then
      module swap PrgEnv-gnu   PrgEnv-$CONDAPRGENV
    fi
fi

