FROM arm32v7/julia:1.0.3-stretch

MAINTAINER SATOSHI TERASAKI

RUN apt-get update && apt-get install -y \
    build-essential \
    bzip2 \
    git \
    fbi \
    imagemagick \
    libgtk-3-dev \
    libpango1.0-0 \
    libglib2.0-0 \
    libcairo2 \
    libpng-dev \
    wget
# install GR dep
RUN apt-get update && apt-get install -y \
    libx11-dev libxft-dev libxt-dev \
    libgl1-mesa-dev python-opengl \
    qt4-dev-tools pyqt4-dev-tools \
    texlive-latex3 dvipng \
    libgs-dev \
    libmupdf-dev \
    libgtk2.0-dev \
    libwxgtk3.0-dev \
    libglfw3-dev \
    libzmq3-dev
RUN cd /tmp && \
    git clone https://github.com/jheinen/gr && \
    cd gr && \
    make GRDIR=/opt/gr && make install && \
    cd ../ && rm -r gr

ENV PATH=/root/berryconda3/bin:$PATH
RUN wget --quiet https://github.com/jjhelmus/berryconda/releases/download/v2.0.0/Berryconda3-2.0.0-Linux-armv7l.sh && \
    /bin/bash Berryconda3-2.0.0-Linux-armv7l.sh -bf && \
    rm Berryconda3-2.0.0-Linux-armv7l.sh
RUN pip install --upgrade pip && \
    pip install julia
RUN conda install -y numpy pandas scipy scikit-learn \
                     matplotlib sympy jupyter
RUN conda install -y -c conda-forge opencv
# install Julia packagess
RUN julia -e 'using Pkg; \
              ENV["PYTHON"] = Sys.which("python"); \
              Pkg.add(["PyCall", "PyPlot", "SymPy", "IJulia"]); \
              using PyCall, PyPlot, SymPy, IJulia'
RUN julia -e 'using Pkg; \
              Pkg.add(["UnicodePlots", "GR", "Plots"]); \
              using UnicodePlots, GR, Plots'
RUN julia -e 'using Pkg; \
              Pkg.add(["Images", "ImageMagick", "ImageMetadata", "TestImages"]); \
              using Images, ImageMagick, ImageMetadata, TestImages'
#do not import/using ImageView here!
RUN julia -e 'using Pkg; Pkg.add("ImageView")'
RUN julia -e 'using Pkg; \
              Pkg.add(["ArgParse", "BenchmarkTools", "Distributed", "Debugger", "JuliaInterpreter", "Revise"]); \
              using ArgParse, BenchmarkTools, Distributed, Debugger, JuliaInterpreter, Revise'
# disable error such that:
# X Error: BadAccess (attempt to access private resource denied) 10
ENV QT_X11_NO_MITSHM=1
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*