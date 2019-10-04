# Build Julia from source on your x86-64 machine, 
# which means it is not instruction for cross compilation, 
# but it will helpful for one who is trying to create script
# to build Julia from source for any device.

FROM ubuntu:16.04

MAINTAINER SATOSHI TERASAKI

ARG JL_VERSION="v1.2.0"

RUN apt-get update && apt-get install -y \
    build-essential \
    libatomic1 \
    python \
    gfortran \
    perl \
    wget \
    m4 \
    cmake \
    pkg-config \
    git

WORKDIR /root
RUN git clone --depth=1 -b $JL_VERSION https://github.com/JuliaLang/julia.git \
    && cd julia \
    && echo "prefix=/usr/local/julia-$JL_VERSION" > Make.user \
    && echo "CXXFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0" >> Make.user \
    && make -j $(nproc) \
    && make install

RUN rm -r /root/julia
ENV PATH=/usr/local/julia-$JL_VERSION/bin:$PATH
# runtime test
RUN julia -e "using InteractiveUtils; versioninfo()"

CMD ["julia"]
