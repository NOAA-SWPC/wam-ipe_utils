#!/bin/ksh
################################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:         global_cycle.sh
# Script description:  Makes a global spectral model surface analysis
#
# Author:        Mark Iredell       Org: NP23         Date: 2005-02-03
#
# Abstract: This script makes a global spectral model surface analysis.
#
################################################################################

#  Set environment.
export VERBOSE=${VERBOSE:-"NO"}
if [[ "$VERBOSE" = "YES" ]] ; then
   echo $(date) EXECUTING $0 $* >&2
   set -x
fi
export machine=${machine:-WCOSS}
export machine=$(echo $machine|tr '[a-z]' '[A-Z]')

#  Command line arguments.
export SFCGES=${1:-${SFCGES:?}}
export SFCANL=${2:-${SFCANL}}

#  Directories.
export DATA=${DATA:-$(pwd)}
export COMIN=${COMIN:-$(pwd)}
export COMOUT=${COMOUT:-$(pwd)}

#  Filenames.
export XC=${XC}
export PREINP=${PREINP:-"${CDUMP}.t${cyc}z."}
export SUFINP=${SUFINP}
export KEEPFH=${KEEPFH:-YES}
export JCAP=${JCAP:-1534}
export SFCHDR=${SFCHDR:-$EXECwsm/global_sfchdr$XC}
export CYCLEXEC=${CYCLEXEC:-$EXECwsm/global_cycle$XC}
export nemsioget=${nemsioget:-$NWPROD/ngac.v1.0.0/exec/nemsio_get}
export NEMSIO_IN=${NEMSIO_IN:-.false.}
export SIGIO_OUT=${SIGIO_OUT:-.true.}
export OUTTYP=${OUTTYP:-2}
if [ ${NEMSIO_OUT:-".true."} = .true. ]; then export OUTTYP=1 ; fi
if [ ${SIGIO_OUT:-".false."} = .true. ]; then export OUTTYP=2 ; fi

if [[ $KEEPFH = YES ]];then
  if [[ $NEMSIO_IN = .true. ]] ; then
    export CDATE=$($nemsioget $SFCGES idate | grep -i "idate" |awk -F= '{print $2}')
    export FHOUR=$($nemsioget $SFCGES nfhour |awk -F"= " '{print $2}' |awk -F" " '{print $1}')
  else
    export CDATE=$($SFCHDR $SFCGES IDATE||echo 0)
    export FHOUR=$($SFCHDR $SFCGES FHOUR||echo 0)
  fi
else
  export CDATE=${CDATE}
  export FHOUR=${FHOUR:-00}
fi
if [[ $NEMSIO_IN = .true. ]] ; then
  export LATB=${LATB:-$($nemsioget $SFCGES LATR |awk -F"= " '{print $2}' |awk -F" " '{print $1}')}
  export LONB=${LONB:-$($nemsioget $SFCGES LONR |awk -F"= " '{print $2}' |awk -F" " '{print $1}')}
  export DELTSFC=${DELTSFC:-$($nemsioget $SFCGES nfhour |awk -F"= " '{print $2}' |awk -F" " '{print $1}')}
else
  export LATB=${LATB:-$($SFCHDR $SFCGES LATB||echo 0)}
  export LONB=${LONB:-$($SFCHDR $SFCGES LONB||echo 0)}
  export DELTSFC=${DELTSFC:-$($SFCHDR $SFCGES FHOUR||echo 0)}
fi
export LSOIL=${LSOIL:-4}
export FSMCL2=${FSMCL2:-60}
export IALB=${IALB:-0}
export ISOT=${ISOT:-0}
export IVEGSRC=${IVEGSRC:-2}
export CYCLVARS=${CYCLVARS}
export NTHREADS=${NTHREADS:-4}
export NTHSTACK=${NTHSTACK:-4096000000}
export use_ufo=${use_ufo:-.false.}
export NST_ANL=${NST_ANL:-.false.}

export FNGLAC=${FNGLAC:-${FIXGLOBAL}/global_glacier.2x2.grb}
export FNMXIC=${FNMXIC:-${FIXGLOBAL}/global_maxice.2x2.grb}
export FNTSFC=${FNTSFC:-${FIXGLOBAL}/cfs_oi2sst1x1monclim19822001.grb}
export FNSNOC=${FNSNOC:-${FIXGLOBAL}/global_snoclim.1.875.grb}
export FNZORC=${FNZORC:-sib}
export FNALBC=${FNALBC:-${FIXGLOBAL}/global_albedo4.1x1.grb}
export FNALBC2=${FNALBC2:-${FIXGLOBAL}/global_albedo4.1x1.grb}
export FNAISC=${FNAISC:-${FIXGLOBAL}/cfs_ice1x1monclim19822001.grb}
export FNTG3C=${FNTG3C:-${FIXGLOBAL}/global_tg3clim.2.6x1.5.grb}
export FNVEGC=${FNVEGC:-${FIXGLOBAL}/global_vegfrac.0.144.decpercent.grb}
export FNVETC=${FNVETC:-${FIXGLOBAL}/global_vegtype.1x1.grb}
export FNSOTC=${FNSOTC:-${FIXGLOBAL}/global_soiltype.1x1.grb}
export FNSMCC=${FNSMCC:-${FIXGLOBAL}/global_soilmgldas.t${JCAP}.${LONB}.${LATB}.grb}
export FNVMNC=${FNVMNC:-${FIXGLOBAL}/global_shdmin.0.144x0.144.grb}
export FNVMXC=${FNVMXC:-${FIXGLOBAL}/global_shdmax.0.144x0.144.grb}
export FNSLPC=${FNSLPC:-${FIXGLOBAL}/global_slope.1x1.grb}
export FNABSC=${FNABSC:-${FIXGLOBAL}/global_snoalb.1x1.grb}
export FNMSKH=${FNMSKH:-${FIXGLOBAL}/seaice_newland.grb}
export FNOROG=${FNOROG:-${FIXGLOBAL}/global_orography.t$JCAP.$LONB.$LATB.rg.grb}
export FNOROG_UF=${FNOROG_UF:-${FIXGLOBAL}/global_orography_uf.t$JCAP.$LONB.$LATB.grb}
export FNMASK=${FNMASK:-${FIXGLOBAL}/global_slmask.t$JCAP.$LONB.$LATB.rg.grb}
export FNTSFA=${FNTSFA:-${COMIN}/${PREINP}sstgrb}
export FNACNA=${FNACNA:-${COMIN}/${PREINP}engicegrb}
export FNSNOA=${FNSNOA:-${COMIN}/${PREINP}snogrb${SNOSUF}}
export SFCANL=${SFCANL:-${COMIN}/${PREINP}sfca03}
export INISCRIPT=${INISCRIPT}
export ERRSCRIPT=${ERRSCRIPT:-'eval [[ $err = 0 ]]'}
export LOGSCRIPT=${LOGSCRIPT}
export ENDSCRIPT=${ENDSCRIPT}
#  Other variables.
export FILESTYLE=${FILESTYLE:-'X'}
export PGMOUT=${PGMOUT:-${pgmout:-'&1'}}
export PGMERR=${PGMERR:-${pgmerr:-'&2'}}
export REDOUT=${REDOUT:-'1>'}
export REDERR=${REDERR:-'2>'}
# Set defaults
################################################################################
#  Preprocessing
$INISCRIPT
pwd=$(pwd)
if [[ -d $DATA ]]
then
   mkdata=NO
else
   mkdir -p $DATA
   mkdata=YES
fi
cd $DATA||exit 99
[[ -d $COMOUT ]]||mkdir -p $COMOUT

################################################################################
#  Make surface analysis
export XLSMPOPTS="parthds=$NTHREADS:stack=$NTHSTACK"
export PGM=$CYCLEXEC
export pgm=$PGM
$LOGSCRIPT

rm $SFCANL
iy=$(echo $CDATE|cut -c1-4)
im=$(echo $CDATE|cut -c5-6)
id=$(echo $CDATE|cut -c7-8)
ih=$(echo $CDATE|cut -c9-10)

export OMP_NUM_THREADS=${OMP_NUM_THREADS_CY:-${CYCLETHREAD:-1}}

cat << EOF > fort.35
&NAMSFC
  FNGLAC="$FNGLAC",
  FNMXIC="$FNMXIC",
  FNTSFC="$FNTSFC",
  FNSNOC="$FNSNOC",
  FNZORC="$FNZORC",
  FNALBC="$FNALBC",
  FNALBC2="$FNALBC2",
  FNAISC="$FNAISC",
  FNTG3C="$FNTG3C",
  FNVEGC="$FNVEGC",
  FNVETC="$FNVETC",
  FNSOTC="$FNSOTC",
  FNSMCC="$FNSMCC",
  FNVMNC="$FNVMNC",
  FNVMXC="$FNVMXC",
  FNSLPC="$FNSLPC",
  FNABSC="$FNABSC",
  FNMSKH="$FNMSKH",
  FNTSFA="$FNTSFA",
  FNACNA="$FNACNA",
  FNSNOA="$FNSNOA",
  LDEBUG=.false.,
  FSMCL(2)=$FSMCL2,
  FSMCL(3)=$FSMCL2,
  FSMCL(4)=$FSMCL2,
  $CYCLVARS
 /
EOF

eval $APRUNCY $CYCLEXEC <<EOF $REDOUT$PGMOUT $REDERR$PGMERR
 &NAMCYC 
  idim=$LONB, jdim=$LATB, lsoil=$LSOIL,
  iy=$iy, im=$im, id=$id, ih=$ih, fh=$FHOUR,
  DELTSFC=$DELTSFC,ialb=$IALB,use_ufo=$use_ufo,NST_ANL=$NST_ANL,
  OUTTYP=$OUTTYP,isot=$ISOT,ivegsrc=$IVEGSRC
 /
 &NAMSFCD
  FNBGSI="$SFCGES",
  FNBGSO="$SFCANL",
  FNOROG="$FNOROG",
  FNOROG_UF="$FNOROG_UF",
  FNMASK="$FNMASK",
  LDEBUG=.false.,
 /
EOF

export ERR=$?
export err=$ERR
$ERRSCRIPT||exit 2

################################################################################
#  Postprocessing
cd $pwd
[[ $mkdata = YES ]]&&rmdir $DATA
$ENDSCRIPT
set +x
if [[ "$VERBOSE" = "YES" ]]
then
   echo $(date) EXITING $0 with return code $err >&2
fi
exit $err
