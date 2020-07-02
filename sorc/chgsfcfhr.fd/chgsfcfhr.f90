program chgsfcfhr
!$$$  main program documentation block
!
! program:  chgsfcfhr     change sfcio header fhour and idate for IAU purposes
!
! prgmmr: kubaryk         org: ncep/emc               date: 2017-06-08
!
! program history log:
!   2017-06-08  Initial version.
!
! usage:
!   input files: sfcio file
!
!   output files: overwrite sfcio file
!
! attributes:
!   language: f95
!
!$$$

  use sfcio_module

  implicit none

  character*500 filenamein
  character*10  idatestr
  character*5   fhourstr
  integer lunin,lunout,iret
  integer year,month,day,hour
  real(sfcio_realkind) fhour

  type(sfcio_head):: sfchead
  type(sfcio_data):: sfcdata

! Get user input from command line
  call getarg(1,filenamein)        ! full path to sfcio file
  call getarg(2,idatestr)          ! new idate
  call getarg(3,fhourstr)          ! new fhour
  read(idatestr(1:4) ,'(i4)') year
  read(idatestr(5:6) ,'(i2)') month
  read(idatestr(7:8) ,'(i2)') day
  read(idatestr(9:10),'(i2)') hour
  read(fhourstr,*)            fhour

  lunin=21
  lunout=61

  call sfcio_srohdc(lunin,trim(filenamein),sfchead,sfcdata,iret)
  write(6,*) "read fnin=",trim(filenamein)," iret=",iret
 
  sfchead%idate(4) = year
  sfchead%idate(2) = month
  sfchead%idate(3) = day
  sfchead%idate(1) = hour
  sfchead%fhour    = fhour

  call sfcio_swohdc(lunout,trim(filenamein),sfchead,sfcdata,iret)
  write(6,*) "write fnout=",trim(filenamein)," iret=",iret

  call sfcio_axdata(sfcdata,iret)

END program chgsfcfhr
