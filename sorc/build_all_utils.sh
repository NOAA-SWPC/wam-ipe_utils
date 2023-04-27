#!/bin/sh
set -eu
#------------------------------------
# Exception handling is now included.
#------------------------------------

target=${1:-"all"}

if [ $target = "install" ] ; then

exit $?

fi

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
# build NEMS util
#------------------------------------
echo " .... Executing ./build_nems_util.sh $target .... "
./build_nems_util.sh $target > $logs_dir/build_NEMS_$target.log 2>&1
#------------------------------------
# build cycle
#------------------------------------
echo " .... Executing ./build_cycle.sh $target .... "
./build_cycle.sh $target > $logs_dir/build_cycle_$target.log 2>&1
#------------------------------------
# build hdr
#------------------------------------
echo " .... Executing ./build_hdr.sh $target .... "
./build_hdr.sh $target > $logs_dir/build_hdr_$target.log 2>&1
#------------------------------------
# build chg
#------------------------------------
echo " .... Executing ./build_chg.sh $target .... "
./build_chg.sh $target > $logs_dir/build_chg_$target.log 2>&1

# extra cleanup
if [ $target = "clean" ] ; then
  rm -f ../exec/*
fi

echo;echo " .... Build system finished .... "

exit 0
