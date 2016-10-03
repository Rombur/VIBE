FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
      build-essential \
      cmake \
      git \
      zlib1g-dev \
      mpich \
      wget \
      libblas-dev \
      liblapack-dev \
      mercurial

ARG TOPDIR="/scratch"
ARG SRCDIR="${TOPDIR}/src"
ARG BUILDDIR="${TOPDIR}/build"
ARG RELEASEDIR="/opt"

ENV TPL_BUILD_DIR="$BUILDDIR/tpls"
ENV TPL_INSTALL_DIR="$RELEASEDIR/tpls"
ENV AMP_BUILD_DIR="$BUILDDIR/amp"
ENV AMPERES_BUILD_DIR="$BUILDDIR/amperes"
ENV AMP_INSTALL_DIR="$RELEASEDIR/amp"
ENV AMPERES_INSTALL_DIR="$RELEASEDIR/amperes"
ENV TPL_SRC_DIR="$SRCDIR/tpls"
ENV TPL_BUILDER="$SRCDIR/TPL-builder"
ENV AMP_SRC_DIR="$SRCDIR/amp"
ENV AMPERES_SRC_DIR="$SRCDIR/amperes"

RUN mkdir -p $TPL_SRC_DIR $TPL_BUILD_DIR $TPL_INSTALL_DIR $AMPERES_BUILD_DIR $AMPERES_INSTALL_DIR $AMP_BUILD_DIR $AMP_INSTALL_DIR

############
# AMP TPLS #
############

# Download AMP TPLs
RUN cd $TPL_SRC_DIR && \
    wget https://bitbucket.org/AdvancedMultiPhysics/tpl-builder/downloads/boost-1.55.0-headers.tar.gz && \
    wget https://bitbucket.org/AdvancedMultiPhysics/tpl-builder/downloads/hypre-2.11.0.tar.gz && \
    wget https://bitbucket.org/AdvancedMultiPhysics/tpl-builder/downloads/libmesh.tar.gz && \
    wget https://bitbucket.org/AdvancedMultiPhysics/tpl-builder/downloads/sundials-2.6.2.tar.gz && \
    wget https://bitbucket.org/AdvancedMultiPhysics/tpl-builder/downloads/petsc-3.2.tar.gz && \
    wget https://bitbucket.org/AdvancedMultiPhysics/tpl-builder/downloads/timerutility.tar.gz && \
    wget https://bitbucket.org/AdvancedMultiPhysics/tpl-builder/downloads/samrutils.tar.gz && \
    wget https://bitbucket.org/AdvancedMultiPhysics/tpl-builder/downloads/hdf5-1.8.12.tar.gz && \
    wget https://bitbucket.org/AdvancedMultiPhysics/tpl-builder/downloads/silo-4.10.2.tar.gz && \
    wget https://bitbucket.org/AdvancedMultiPhysics/tpl-builder/downloads/trilinos-12.6.1-Source.tar.gz

# Download DTK and DTKData
RUN cd $TPL_SRC_DIR && git clone https://github.com/ORNL-CEES/DataTransferKit.git
RUN cd $TPL_SRC_DIR && git clone https://github.com/ORNL-CEES/DTKData.git

# Extract Trilinos
RUN cd $TPL_SRC_DIR && tar xf trilinos-12.6.1-Source.tar.gz

# Add the symbolic links
RUN cd $TPL_SRC_DIR/trilinos-12.6.1-Source && ln -s ${TPL_SRC_DIR}/DataTransferKit
RUN cd $TPL_SRC_DIR/DataTransferKit && ln -s ${TPL_SRC_DIR}/DTKData

# Download TPL-builder
RUN cd $SRCDIR && hg clone https://bitbucket.org/AdvancedMultiPhysics/tpl-builder $TPL_BUILDER

ENV TRILINOS_EXTRA_FLAGS="-DTrilinos_ENABLE_ALL_PACKAGES=OFF;"
ENV TRILINOS_EXTRA_FLAGS="-DBUILD_SHARED_LIBS=ON;${TRILINOS_EXTRA_FLAGS}"
ENV TRILINOS_EXTRA_FLAGS="-DTrilinos_EXTRA_REPOSITORIES=DataTransferKit;${TRILINOS_EXTRA_FLAGS}"
ENV TRILINOS_EXTRA_FLAGS="-DTrilinos_ENABLE_DataTransferKit=ON;${TRILINOS_EXTRA_FLAGS}"
ENV TRILINOS_EXTRA_FLAGS="-DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF;${TRILINOS_EXTRA_FLAGS}"
ENV TRILINOS_EXTRA_FLAGS="-DTPL_ENABLE_Netcdf=OFF;${TRILINOS_EXTRA_FLAGS}"
ENV TRILINOS_EXTRA_FLAGS="-DTPL_ENABLE_BoostLib=OFF;${TRILINOS_EXTRA_FLAGS}"
ENV TRILINOS_EXTRA_FLAGS="-DTPL_ENABLE_MOAB=OFF;${TRILINOS_EXTRA_FLAGS}"
ENV TRILINOS_EXTRA_FLAGS="-DTPL_ENABLE_Libmesh=OFF;${TRILINOS_EXTRA_FLAGS}"

# Build the TPLs
ENV TPL_LIST="TIMER;ZLIB;BOOST;HDF5;LAPACK;HYPRE;PETSC;SILO;SUNDIALS;TRILINOS;LIBMESH"

RUN cd $TPL_BUILD_DIR && cmake                                  \
  -D CMAKE_BUILD_TYPE=Release                                   \
  -D C_COMPILER=mpicc                                           \
  -D CXX_COMPILER=mpicxx                                        \
  -D Fortran_COMPILER=mpif90                                    \
  -D CXX_STD=11                                                 \
  -D ENABLE_STATIC:BOOL=OFF                                     \
  -D ENABLE_SHARED:BOOL=ON                                      \
  -D INSTALL_DIR:PATH=${TPL_INSTALL_DIR}                        \
  -D PROCS_INSTALL=8                                            \
  -D ENABLE_TESTS:BOOL=ON                                       \
  -D TPL_LIST:STRING="$TPL_LIST"                                \
    -D BOOST_URL="${TPL_SRC_DIR}/boost-1.55.0-headers.tar.gz"   \
      -D BOOST_ONLY_COPY_HEADERS:BOOL=true                      \
    -D LAPACK_INSTALL_DIR="/usr/lib"                            \
    -D ZLIB_INSTALL_DIR="/usr"                                  \
      -D ZLIB_INCLUDE_DIR="/usr/include"                        \
      -D ZLIB_LIB_DIR="/usr/lib/x86_64-linux-gnu"               \
    -D HDF5_URL="${TPL_SRC_DIR}/hdf5-1.8.12.tar.gz"             \
    -D SILO_URL="${TPL_SRC_DIR}/silo-4.10.2.tar.gz"             \
    -D HYPRE_URL="${TPL_SRC_DIR}/hypre-2.11.0.tar.gz"           \
    -D LIBMESH_URL="${TPL_SRC_DIR}/libmesh.tar.gz"              \
    -D TRILINOS_SRC_DIR="${TPL_SRC_DIR}/trilinos-12.6.1-Source" \
      -D TRILINOS_EXTRA_FLAGS="$TRILINOS_EXTRA_FLAGS"           \
      -D TRILINOS_PACKAGES="Epetra;Thyra;ML;Kokkos;Amesos"      \
    -D SUNDIALS_URL="${TPL_SRC_DIR}/sundials-2.6.2.tar.gz"      \
    -D PETSC_URL="${TPL_SRC_DIR}/petsc-3.2.tar.gz"              \
    -D TIMER_URL="${TPL_SRC_DIR}/timerutility.tar.gz"           \
      -D TIMER_USE_MATLAB:BOOL=false                            \
  ${TPL_BUILDER}

RUN cd $TPL_BUILD_DIR && make


#######
# AMP #
#######

# Download AMP
RUN cd $SRCDIR && hg clone https://bitbucket.org/AdvancedMultiPhysics/amp $AMP_SRC_DIR

# Download AMP-Data
RUN cd $SRCDIR && \
wget -O AMP-Data.tar.gz https://bitbucket.org/AdvancedMultiPhysics/amp/downloads/AMP-Data.tar.gz && \
tar -xf AMP-Data.tar.gz -C $RELEASEDIR

# Build AMP
RUN cd $AMP_BUILD_DIR && cmake                                  \
  -D TPL_DIRECTORY=${TPL_INSTALL_DIR}                           \
  -D AMP_DATA=${RELEASEDIR}/AMP-Data                            \
  -D USE_EXT_DTK=1                                              \
  -D USE_EXT_DOXYGEN=0                                          \
  -D AMP_INSTALL_DIR=${AMP_INSTALL_DIR}                         \
  ${AMP_SRC_DIR}

RUN cd $AMP_BUILD_DIR && make -j 8 install


###########
# AMPERES #
###########

# Copy AMPERES
COPY amperes $SRCDIR/amperes

# Copy AMPERES-Data
COPY amperes-data $RELEASEDIR/amperes-data

# Comment SET(AMP_LIBS amp) in amp.cmake
RUN cd $AMP_INSTALL_DIR && sed -i /AMP_LIBS/s/^/\#/ amp.cmake

# Comment a test that does not compile
RUN cd $SRCDIR/amperes/src/test && sed -i /testNHTSAModuleShort/s/^/\#/ CMakeLists.txt

# Build AMPERES
RUN cd $AMPERES_BUILD_DIR && cmake                              \
  -D AMP_DIRECTORY=${AMP_INSTALL_DIR}                           \
  -D USE_CANTERA=OFF                                            \
  -D AMPERES_DATA="${RELEASEDIR}/amperes-data"                  \
  -D AMPERES_INSTALL_DIR=${AMPERES_INSTALL_DIR}                 \
  ${AMPERES_SRC_DIR}

RUN cd $AMPERES_BUILD_DIR && make -j 8 install

# Move AMPERES test to INSTALL_DIR
RUN cp -a $AMPERES_BUILD_DIR/src/test $AMPERES_INSTALL_DIR

# Add AMPERES to LD_LIBRARY_PATH so the tests that have been moved can run
ENV LD_LIBRARY_PATH="/opt/amperes/lib"

# Remove unnecessary directory
RUN rm -rf /scratch /var/lib/apt/lists/* /tmp/* /var/tmp/* /opt/AMP-Data
