#!/bin/bash

###################################################################
# This build assumes that you have an "mpif90" in your PATH that is
# set up to use your chosen MPI library and compiler.
##################################################################

#################################################################
# Please set the location of your HDF5 include and library files. 
# Make sure the HDF5 library is compiled with 
# the same compiler currently being used and that the 
# library is in your run-time environment (e.g. LD_LIBRARY_PATH).
#################################################################

#  Ubuntu 20.x
#HDF5_INCLUDE_DIR="/usr/include/hdf5/serial"
#HDF5_LIB_DIR="/usr/lib/x86_64-linux-gnu"

#  Locally installed
HDF5_INCLUDE_DIR="/opt/psi/nv/ext_deps/deps/hdf5/include"
HDF5_LIB_DIR="/opt/psi/nv/ext_deps/deps/hdf5/lib"

###########################################################################
# Please set the HDF5 linker flags to match your installed version of hdf5.
###########################################################################

#  Ubuntu 20.x
#HDF5_LIB_FLAGS="-lhdf5_serial_fortran -lhdf5_serialhl_fortran -lhdf5_serial -lhdf5_serial_hl"

#  Locally installed
HDF5_LIB_FLAGS="-lhdf5_fortran -lhdf5hl_fortran -lhdf5 -lhdf5_hl"

###########################################################################
# Please set the compile flags based on your compiler and hardware setup.
# Examples:
#   GNU (CPU):     FFLAGS="-O3 -march=native"
#   NV/PGI (CPU):  FFLAGS="-O3 -march=native"
#   NV/PGI (GPU):  FFLAGS="-O3 -march=native -acc=gpu -gpu=cc80,cuda11.4 -Minfo=accel"
#   INTEL (CPU):   FFLAGS="-O3 -fp-model precise -assume byterecl 
#                              -heap-arrays -xCORE-AVX2 -axCORE-AVX512"
###########################################################################

FFLAGS="-march=native -acc=gpu -gpu=cc61,cc75,cuda11.4 -Minfo=accel"

###########################################################################
###########################################################################
###########################################################################

HIPFT_HOME=$PWD

cd ${HIPFT_HOME}/src
cp Makefile.template Makefile
sed -i "s#<FFLAGS>#${FFLAGS}#g" Makefile
sed -i "s#<HDF5_INCLUDE_DIR>#${HDF5_INCLUDE_DIR}#g" Makefile
sed -i "s#<HDF5_LIB_DIR>#${HDF5_LIB_DIR}#g" Makefile
sed -i "s#<HDF5_LIB_FLAGS>#${HDF5_LIB_FLAGS}#g" Makefile
echo "make 1>build.log 2>build.err"
make 1>build.log 2>build.err

echo "cp ${HIPFT_HOME}/src/hipft ${HIPFT_HOME}/bin/hipft"
cp ${HIPFT_HOME}/src/hipft ${HIPFT_HOME}/bin/hipft

