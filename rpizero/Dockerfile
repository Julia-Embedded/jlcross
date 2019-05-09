# Build Julia binary for arm32-bit devices e.g. RaspberryPi Zero(W/WH)

FROM balenalib/raspberry-pi:stretch

ARG VERSION="1.1.0"

MAINTAINER SATOSHI TERASAKI

# install dependencies
RUN apt-get update && \
    apt-get install -y build-essential libatomic1 python gfortran perl wget m4 cmake pkg-config \
    libopenblas-base libopenblas-dev \
    libatlas3-base libatlas-base-dev \
    liblapack-dev \
    libmpfr-dev libgmp3-dev \
    libgfortran3 \
    git

# build julia from source
ARG WDIR=/home/pi/work
ARG JL_BUILD_DIR=$WDIR/build
WORKDIR $WDIR
RUN echo "\
JULIA_CPU_TARGET=arm1176jzf-s\n\
prefix=$WDIR/julia-$VERSION\n\
override USE_SYSTEM_BLAS=1\n\
override USE_SYSTEM_LAPACK=1\n\
override USE_SYSTEM_LIBM=1\n\
override USE_SYSTEM_GMP=1\n\
override USE_SYSTEM_MPFR=1\n\
" > Make.user && \
    cat Make.user && \
    git clone --depth=1 -b v$VERSION https://github.com/JuliaLang/julia.git $JL_BUILD_DIR &&\
    cp Make.user $JL_BUILD_DIR && \
    cd $JL_BUILD_DIR && make OPENBLAS_USE_THREAD=0 -j 8 && make install

# add path of Julia
ENV PATH=$WDIR/julia-$VERSION/bin:$PATH

# clean up
RUN rm -r $JL_BUILD_DIR $WDIR/Make.user
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
