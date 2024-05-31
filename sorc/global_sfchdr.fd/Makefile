SHELL	=/bin/sh
INCMOD	= $(SFCIO_INC)
INSTALL = ../../exec
SRCM	= sfchdr.f
INCM	=
SRCS	=
OBJS	=
MODS	=
FC	= ifort
#FFLAGS	=-qnosave -O2   -qmaxmem=-1
FFLAGS  = -O2 -xHOST -convert big_endian -traceback -g -FR
LDFLAGS	=   
LIBS    = $(SFCIO_LIB) $(BACIO_LIB4) $(W3EMC_LIB4)
CMD	=global_sfchdr
$(CMD):	$(SRCM) $(OBJS)
	$(FC) -I $(INCMOD) $(FFLAGS) $(LDFLAGS) $(SRCM) $(OBJS) $(LIBS) -o $(CMD)
clean:
	-rm -f $(OBJS) $(MODS)
clobber:        clean
	-rm -f $(CMD)
void:   clobber
	-rm -f $(SRCS) $(SRCM) $(INCM) makefile
install:
	cp $(CMD) $(INSTALL)
