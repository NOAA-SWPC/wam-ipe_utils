program chgsigfhr
!$$$  main program documentation block
!
! program:  chgsigfhr     change sigio header fhour and idate
!
! prgmmr: kubaryk         org: ncep/emc               date: 2017-06-12
!
! program history log:
!   2017-06-12  Initial version
!
! usage:
!   input files: sigio file
!
!   output files: overwrite sigio file
!
! attributes:
!   language: f95
!
!$$$

  use sigio_module

  implicit none

  character*500 filenamein
  character*10  idatestr
  character*5   fhourstr
  integer lunin,lunout,iret
  integer year,month,day,hour
  real(sigio_realkind) fhour

  type(sigio_head):: sighead
  type(sigio_data):: sigdata

! Get user input from command line
  call getarg(1,filenamein)        ! full path to sigio file
  call getarg(2,idatestr)          ! new idate
  call getarg(3,fhourstr)          ! new fhour
  read(idatestr(1:4) ,'(i4)') year
  read(idatestr(5:6) ,'(i2)') month
  read(idatestr(7:8) ,'(i2)') day
  read(idatestr(9:10),'(i2)') hour
  read(fhourstr,*)            fhour

  lunin=21
  lunout=61

  call sigio_srohdc(lunin,trim(filenamein),sighead,sigdata,iret)
  write(6,*) "read fnin=",trim(filenamein)," iret=",iret
 
  sighead%idate(4) = year
  sighead%idate(2) = month
  sighead%idate(3) = day
  sighead%idate(1) = hour
  sighead%fhour    = fhour

  call sigio_swohdc(lunout,trim(filenamein),sighead,sigdata,iret)
  write(6,*) "write fnout=",trim(filenamein)," iret=",iret

  call sigio_axdata(sigdata,iret)

END program chgsigfhr
