#!/bin/bash
set -x
target=${1:-"all"}

if [ $target != "clean" ] ; then
#-----------------------------------------------------
#-use standard module.
#-----------------------------------------------------

export FCMP=${FCMP:-ifort}

##export DEBUG='-ftrapuv -check all -check nooutput_conversion -fp-stack-check -fstack-protector -traceback -g'
export INCS="-I${SFCIO_INC} -I$W3EMC_INCd -I$NEMSIO_INC -I${NEMSIOGFS_INC}"
export FFLAGS="$INCS -O3 -r8 -convert big_endian -traceback -g"
export OMPFLAG=-qopenmp
export LDFLG=-qopenmp

export LIBSM="${NEMSIOGFS_LIB} \
              ${NEMSIO_LIB} \
              ${W3EMC_LIBd} \
              ${SFCIO_LIB} \
              ${W3EMC_LIBd} \
              ${BACIO_LIB4} \
              ${SP_LIBd} "

make -f Makefile
make -f Makefile install

else
make -f Makefile clean
fi
