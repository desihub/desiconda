for PRGENV in $(echo gnu intel cray nvidia)
do
  mod=`module -t list 2>&1 | grep PrgEnv-$PRGENV`
  if [ "x$mod" != x ] ; then
    if [ $PRGENV != $CONDAPRGENV ] ; then
      echo "swapping PrgEnv-$PRGENV for PrgEnv-$CONDAPRGENV"
      module swap PrgEnv-$PRGENV PrgEnv-$CONDAPRGENV
    fi
  fi
done
