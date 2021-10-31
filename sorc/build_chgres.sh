#! /usr/bin/env bash
set -eux

source ./machine-setup.sh > /dev/null 2>&1
cwd=`pwd`

module purge

USE_PREINST_LIBS=${USE_PREINST_LIBS:-"true"}
if [ $USE_PREINST_LIBS = true ]; then
  export MOD_PATH
  if [ $target = wcoss2 ] ; then
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
    source ../modulefiles/fv3gfs/global_chgres.${target}_userlib > /dev/null 2>&1
  else
    source ../modulefiles/fv3gfs/global_chgres.$target           > /dev/null 2>&1
  fi
fi

# Check final exec folder exists
if [ ! -d "../exec" ]; then
  mkdir ../exec
fi

#
# --- Chgres part
#
cd global_chgres.fd

export FCMP=${FCMP:-ifort}
export FCMP95=$FCMP

export FFLAGSM="-i4 -O3 -r8  -convert big_endian -fp-model precise"
export FFLAGS2M="-i4 -O3 -r8 -convert big_endian -fp-model precise -FR"
export RECURS=
export LDFLAGSM="-qopenmp -auto"
export OMPFLAGM="-qopenmp -auto"

export INCS="-I${SIGIO_INC4} -I${SFCIO_INC4} -I${LANDSFCUTIL_INCd} \
             -I${NEMSIO_INC} -I${NEMSIOGFS_INC} -I${GFSIO_INC4} -I${IP_INCd} "

export LIBSM="${GFSIO_LIB4} \
              ${NEMSIOGFS_LIB} \
              ${NEMSIO_LIB} \
              ${SIGIO_LIB4} \
              ${SFCIO_LIB4} \
              ${LANDSFCUTIL_LIBd} \
              ${IP_LIBd} \
              ${SP_LIBd} \
              ${W3EMC_LIBd} \
              ${W3NCO_LIBd} \
              ${BACIO_LIB4} "

make -f Makefile clobber
make -f Makefile
make -f Makefile install
make -f Makefile clobber

exit
