#!/bin/sh
set -eux

source ./machine-setup.sh > /dev/null 2>&1
cwd=`pwd`

module purge

USE_PREINST_LIBS=${USE_PREINST_LIBS:-"true"}
if [ $USE_PREINST_LIBS = true ]; then
  export MOD_PATH
  if [ $target = wcoss2 ]; then
    module reset
    source ../modulefiles/module_base.$target
  else
    module use ../modulefiles
    module load module_base.$target             > /dev/null 2>&1
  fi
else
  export MOD_PATH=${cwd}/lib/modulefiles
  if [ $target = wcoss_cray ]; then
    source ../modulefiles/module_nemsutil.${target}_userlib > /dev/null 2>&1
  else
    source ../modulefiles/module_nemsutil.$target           > /dev/null 2>&1
  fi
fi

# Check final exec folder exists
if [ ! -d "../exec" ]; then
  mkdir ../exec
fi

for prog in nemsio_get.fd ;do
 cd ${cwd}/${prog}
 make -f makefile
done

exit
