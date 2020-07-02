SHELL=/bin/sh

CP              = /bin/cp -p
RM              = /bin/rm -f
MKDIR           = /bin/mkdir -p
AR              = ar cq
PROTEX          = protex -f # -l
ProTexMake      = protex -S # -l
LATEX           = pdflatex
DVIPS           = dvips

# Preprocessing
# -------------
_DDEBUG =
_D      = $(_DDEBUG)

# ------------------------
# Default System Libraries
# ------------------------
LIBmpi          = -lmpi
LIBsys          = 


#------------
# Include machine dependent compile & load options
#------------
  MAKE_CONF = Makefile.conf
include $(MAKE_CONF)


# -------------
# This makefile
# -------------

  MAKE_FILE = Makefile


# -----------
# Load module
# -----------

  EXE_FILE = chgsfcfhr


# --------------------
# Installing directory
# --------------------

  INSTALL_DIR = ../../exec


# --------
# Log file
# --------

  LOG_FILE = log.make.$(EXE_FILE)


# ---------------
# Call child make
# ---------------

"" :
	@$(MAKE) -f $(MAKE_FILE) all
$(EXE_FILE) :  $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

# ------------
# Source files
# ------------

  SRCSF90C = chgsfcfhr.f90

  SRCSF77 =

  SRCSC =

  SRCS = $(SRCSF90C) $(SRCSF77) $(SRCSC)

  DOCSRCS = *.f90 *.F90

# ------------
# Object files
# ------------

  SRCSF90       = ${SRCSF90C:.F90=.f90}

  OBJS          = ${SRCSF90:.f90=.o} ${SRCSF77:.f=.o} ${SRCSC:.c=.o}


# -----------------------
# Default compiling rules
# -----------------------

.SUFFIXES :
.SUFFIXES : .F90 .f90 .f .c .o

.F90.o  :
	@echo
	@echo '---> Compiling $<'
	$(CF) $(FFLAGS) $(_D) -c $<

.f90.o  :
	@echo
	@echo '---> Compiling $<'
	$(CF) $(FFLAGS) -c $<

.f.o  :
	@echo
	@echo '---> Compiling $<'
	$(CF) $(FFLAGS_f) -c $<

.c.o  :
	@echo
	@echo '---> Compiling $<'
	$(CC) $(CFLAGS) -c $<

# ------------
# Make install
# ------------

install:
	@echo
	@echo '==== INSTALL ================================================='
	@if [ -e $(INSTALL_DIR) ]; then \
	  if [ ! -d $(INSTALL_DIR) ]; then \
	    echo '### Fail to create installing directory ###' ;\
	    echo '### Stop the installation               ###' ;\
	    exit ;\
	  fi ;\
	else \
	  echo "	mkdir -p $(INSTALL_DIR)" ;\
	  mkdir -p $(INSTALL_DIR) ;\
	fi
	cp $(EXE_FILE) $(INSTALL_DIR)
	@cd $(INSTALL_DIR) ; ls -l `pwd`/$(EXE_FILE)


# ----------
# Make clean
# ----------

clean:
	@echo
	@echo '==== CLEAN ==================================================='
	- $(RM) $(EXE_FILE) *.o *.mod *.MOD *.lst *.a *.x

all:
	@$(MAKE) -f $(MAKE_FILE) "FFLAGS=$(FFLAGS_N)" "CFLAGS=$(CFLAGS_N)" $(OBJS)
	@$(MAKE) -f $(MAKE_FILE) "LIBS=$(LIBS_N)" "LDFLAGS=$(LDFLAGS_N)" $(EXE_FILE)
