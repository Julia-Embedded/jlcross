# Build Julia binary for arm64-bit devices e.g. Jetson-nano,
# sudo docker build -t terasakisatoshi/jlcross:jetson-nano-1.5.1 .

FROM multiarch/ubuntu-core:arm64-xenial

ARG VERSION="v1.5.2"

MAINTAINER SATOSHI TERASAKI

# install dependencies
RUN apt-get update && \
    apt-get install -y build-essential libatomic1 python gfortran perl wget m4 cmake pkg-config \
    git && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# build julia from source
ARG WDIR=/home/jetson-nano/work
ARG JL_BUILD_DIR=$WDIR/build
WORKDIR $WDIR
RUN echo "\
prefix=$WDIR/julia-$VERSION\n\
JULIA_CPU_TARGET=generic\n\
MARCH=armv8-a\n\
USE_BINARYBUILDER=0\n\
" > Make.user && \
    cat Make.user && \
    git clone --depth=1 -b $VERSION https://github.com/JuliaLang/julia.git $JL_BUILD_DIR && \
    cp Make.user $JL_BUILD_DIR && \
    cd $JL_BUILD_DIR && make -j 16 && make install && \
    rm -r $JL_BUILD_DIR $WDIR/Make.user

# add path of Julia
ENV PATH=$WDIR/julia-$VERSION/bin:$PATH
# runtime test
RUN julia -e "using InteractiveUtils; versioninfo()"
CMD ["julia"]
