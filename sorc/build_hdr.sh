#! /usr/bin/env bash
set -eux

source ./machine-setup.sh > /dev/null 2>&1
cwd=`pwd`

USE_PREINST_LIBS=${USE_PREINST_LIBS:-"true"}
if [ $USE_PREINST_LIBS = true ]; then
  export MOD_PATH
  if [ $target = wcoss2 ] ; then
    module reset
  fi
  module use ../modulefiles
  module load module_base.$target             > /dev/null 2>&1
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

for dir in global_sighdr.fd global_sfchdr.fd ; do
  cd $dir
  make clobber
  make
  make install
  make clobber
  cd ..
done
