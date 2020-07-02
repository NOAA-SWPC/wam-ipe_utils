#!/bin/sh
set -eu
#------------------------------------
# USER DEFINED STUFF:
#
# USE_PREINST_LIBS: set to "true" to use preinstalled libraries.
#                   Anything other than "true"  will use libraries locally.
#------------------------------------

export USE_PREINST_LIBS="true"

#------------------------------------
# END USER DEFINED STUFF
#------------------------------------

build_dir=`pwd`
logs_dir=$build_dir/logs
if [ ! -d $logs_dir  ]; then
  echo "Creating logs folder"
  mkdir $logs_dir
fi

# Check final exec folder exists
if [ ! -d "../exec" ]; then
  echo "Creating ../exec folder"
  mkdir ../exec
fi

#------------------------------------
# INCLUDE PARTIAL BUILD
#------------------------------------

. ./partial_build.sh

#------------------------------------
# build NEMS util
#------------------------------------
$Build_nems_util && {
echo " .... Building NEMS util .... "
./build_nems_util.sh > $logs_dir/build_NEMS.log 2>&1
}

#------------------------------------
# build chgres
#------------------------------------
$Build_chgres && {
echo " .... Building chgres .... "
./build_chgres.sh > $logs_dir/build_chgres.log 2>&1
}

#------------------------------------
# build cycle
#------------------------------------
$Build_cycle && {
echo " .... Building cycle .... "
./build_cycle.sh > $logs_dir/build_cycle.log 2>&1
}

#------------------------------------
# build hdr
#------------------------------------
$Build_hdr && {
echo " .... Building hdr .... "
./build_hdr.sh > $logs_dir/build_cycle.log 2>&1
}

#------------------------------------
# build chg
#------------------------------------
$Build_chg && {
echo " .... Building chg .... "
./build_chg.sh > $logs_dir/build_cycle.log 2>&1
}

echo;echo " .... Build system finished .... "

exit 0
