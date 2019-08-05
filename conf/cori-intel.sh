loadedgnu=`${MODULESHOME}/bin/modulecmd sh -t list 2>&1 | grep PrgEnv-gnu`
loadedintel=`${MODULESHOME}/bin/modulecmd sh -t list 2>&1 | grep PrgEnv-intel`
loadedcray=`${MODULESHOME}/bin/modulecmd sh -t list 2>&1 | grep PrgEnv-cray`
loadeddarshan=`${MODULESHOME}/bin/modulecmd sh -t list 2>&1 | grep darshan`
if [ "x${loadedintel}" = x ]; then
    if [ "x${loadedcray}" != x ]; then
      module swap PrgEnv-cray PrgEnv-intel
    fi
    if [ "x${loadedgnu}" != x ]; then
      module swap PrgEnv-gnu PrgEnv-intel
    fi
fi
module unload darshan
module unload altd
module unload craype-hugepages2M
module load gcc
export CRAYPE_LINK_TYPE=dynamic

