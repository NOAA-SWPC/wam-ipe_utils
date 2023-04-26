#! /usr/bin/env bash
set -eux

source ./machine-setup.sh > /dev/null 2>&1
cwd=`pwd`

module purge

USE_PREINST_LIBS=${USE_PREINST_LIBS:-"true"}
if [ $USE_PREINST_LIBS = true ]; then
  export MOD_PATH
  if [ $target = wcoss2 ] ; then
    module reset
    source ../modulefiles/module_base.$target
    export SIGIO_INC4=$SIGIO_INC
    export SIGIO_LIB4=$SIGIO_LIB
    export SFCIO_INC4=$SFCIO_INC
    export SFCIO_LIB4=$SFCIO_LIB
    export GFSIO_INC4=$GFSIO_INC
    export GFSIO_LIB4=$GFSIO_LIB
  else
    module use ../modulefiles
    module load module_base.$target             > /dev/null 2>&1
  fi
else
  export MOD_PATH=${cwd}/lib/modulefiles
  if [ $target = wcoss_cray ]; then
    source ../modulefiles/fv3gfs/global_cycle.${target}_userlib > /dev/null 2>&1
  else
    source ../modulefiles/fv3gfs/global_cycle.$target           > /dev/null 2>&1
  fi
fi
module list

# Check final exec folder exists
if [ ! -d "../exec" ]; then
  mkdir ../exec
fi

cd ${cwd}/global_cycle.fd
./makefile.sh
