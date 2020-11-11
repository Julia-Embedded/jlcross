# Build Julia binary for arm64-bit devices e.g. Jetson-nano.
# terasakisatoshi/jlcross:jetson-v1.5.1

FROM  balenalib/jetson-nano:buster-20200518

ARG VERSION="v1.5.3"

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
JULIA_CPU_TARGET=generic\n\
MARCH=armv8-a\n\
prefix=$WDIR/julia-$VERSION\n\
" > Make.user && \
    cat Make.user && \
    git clone --depth=1 -b $VERSION https://github.com/JuliaLang/julia.git $JL_BUILD_DIR && \
    cp Make.user $JL_BUILD_DIR && \
    # add patches
    sed -i -e '69s/devnull/stdout/' ${JL_BUILD_DIR}/contrib/generate_precompile.jl && \
    sed -i -e '63,65 s/Pkg\.precompile_script/Pkg.precompile_script\[begin\:189\] \* \"\$(CTRL_C)\$(CTRL_C)exit()\"/' ${JL_BUILD_DIR}/contrib/generate_precompile.jl && \
    sed -i -e '190 s/^/#/'       ${JL_BUILD_DIR}/contrib/generate_precompile.jl && \
    cat ${JL_BUILD_DIR}/contrib/generate_precompile.jl && \
    cd $JL_BUILD_DIR && make -j 16 && make install && \
    rm -r $JL_BUILD_DIR $WDIR/Make.user

# add path of Julia
ENV PATH=$WDIR/julia-$VERSION/bin:$PATH
# runtime test
RUN julia -e "using InteractiveUtils; versioninfo()"
CMD ["julia"]
