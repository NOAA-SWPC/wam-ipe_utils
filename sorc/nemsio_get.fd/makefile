EXEC    =../../exec/nemsio_get
FOPTS   =-O -FR -I$(NEMSIO_INC) -convert big_endian
LOPTS   = $(OPTS)
LIBS    =$(NEMSIO_LIB) $(BACIO_LIB4) $(W3NCO_LIBd)
OBJS = nemsio_get.o
SRCS = nemsio_get.f
RM = /bin/rm -f
# *************************************************************************
all: ${OBJS}
$(OBJS): $(SRCS)
	$(FCMP)  $(FOPTS) $(LOPTS) $(SRCS) -o $(EXEC) $(LIBS)

clean:
	- $(RM) $(EXEC) *.o *.mod *.MOD *.lst *.a *.x

