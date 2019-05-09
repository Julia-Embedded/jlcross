# Build Julia binary for arm32-bit armv7-a devices e.g. RaspberryPi 2 or 3

FROM balenalib/raspberrypi3:stretch-run-20181207

ARG VERSION="1.1.0"

MAINTAINER SATOSHI TERASAKI

RUN [ "cross-build-start" ]

# insta dependencies
RUN apt-get update && \
    apt-get install -y build-essential libatomic1 python gfortran perl wget m4 cmake pkg-config \
    git

# build julia from source
ARG WDIR=/home/jetson-nano/work
ARG JL_BUILD_DIR=$WDIR/build
WORKDIR $WDIR
RUN echo "\
JULIA_CPU_TARGET=cortex-a7\n\
MARCH=armv7-a\n\
prefix=/home/pi/work/julia-$VERSION\n\
" > Make.user && \
    cat Make.user && \
    git clone --depth=1 -b v$VERSION https://github.com/JuliaLang/julia.git $JL_BUILD_DIR &&\
    cp Make.user $JL_BUILD_DIR && \
    cd $JL_BUILD_DIR && make -j 8 && make install

# add path of Julia
ENV PATH=$WDIR/julia-$VERSION/bin:$PATH

# clean up
RUN rm -r $JL_BUILD_DIR
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN [ "cross-build-end" ]
