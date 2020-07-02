SHELL   =/bin/sh
INCMOD  = $(SIGIO_INC4)
INSTALL = ../../exec
SRCM    =sighdr.f
INCM    =
SRCS    =
OBJS    =
MODS    =
FC      = ifort
LDFLAGS =
LIBS    = $(SIGIO_LIB4) $(BACIO_LIB4) $(W3NCO_LIB4)
CMD     =global_sighdr
FFLAGS  = -O2 -xHOST -convert big_endian -traceback -g -FR
$(CMD): $(SRCM) $(OBJS)
	$(FC) -I $(INCMOD) $(FFLAGS) $(LDFLAGS) $(SRCM) $(OBJS) $(LIBS) -o $(CMD)
clean:
	-rm -f $(OBJS) $(MODS)
clobber:	clean
	-rm -f $(CMD)
void:	clobber
	-rm -f $(SRCS) $(SRCM) $(INCM) makefile
install:
	cp $(CMD) $(INSTALL)




