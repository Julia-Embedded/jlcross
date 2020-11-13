# jlcross

Dockerfiles for arm devices e.g. Raspberry Pi Series

![image](https://user-images.githubusercontent.com/16760547/99069776-5c8d2780-25f2-11eb-8517-8b201ea28c90.png)

![image](https://user-images.githubusercontent.com/16760547/99069656-20f25d80-25f2-11eb-9014-31ae79538b75.png)


# About [this repository](https://github.com/terasakisatoshi/jlcross)

- This repository contains several Dockerfiles which build Julia (binary/docker-image) for (some) Arm devices e.g. Raspberry Pi Series (also including Zero) using cross compilation.
- Since Julia for Arm32bit system bump downs from Tier2 to Tier3, the official homepage does not provide pre-build binary. If you like to use a Julia version of more than 1.4.1, you have to build by yourself.

## What we believe.

- We believe that not a few people want to run Julia on Raspberry Pi.
- Raspberry Pi was originally used for educational purposes as an inexpensive computer, but it is now used for industrial purposes (e.g. IoT device or edge computing device) as well. Julia is currently the ONLY programming language that is as dynamic, easy to write, like Python and high performance and as good (or faster) than C on Raspberry Pi. If the Julia community ignores Raspberry Pi, it will deprive them of the opportunity to take advantage of Julia's industrial applications.

## Wait! Can we REALLY construct an application for RPis?

- The answer is YES, [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl) can compile Julia application that runs on RaspberryPi's and provide　an executable file.　You can deploy them to another RaspberryPi. The following examples provides simple applications:
  - https://github.com/terasakisatoshi/HelloX.jl
  - https://github.com/terasakisatoshi/CameraApp.jl

- You should checkout Julia discourse to learn more!!!
  - [Have a try Julia v1.4.2 for arm32bit](https://discourse.julialang.org/t/have-a-try-julia-v1-4-2-for-arm32bit/40284)
  - [Have a try Julia v1.5.1 for arm32bit](https://discourse.julialang.org/t/have-a-try-julia-v1-5-1-for-arm32bit/45558)
- Also, there are great posts regarding to Julia package for RPi families:
    - [[ANN] Introducing BaremetalPi.jl - A package to access Raspberry Pi peripherals without external libraries](https://discourse.julialang.org/t/ann-introducing-baremetalpi-jl-a-package-to-access-raspberry-pi-peripherals-without-external-libraries/41417)

## Wow, really cool. Can I help jlcross ?

- If you know a lot of Raspberry Pi system or eager to use Julia on your Raspberry Pi, please help/contribute [Julia community](https://github.com/JuliaLang/julia) rather than here.
- Note that this jlcross repository just only provides Dockerfiles.

# How to use

- We will assume your build machine is
  - Linux machine equipped with high-end CPU
  - macOS (Catalina) e.g. iMac
  - WSL ??? (not tested)

## Read the official documentation/repositories.

- We recommend that you read through/checkout the following links. Once you've read through how to build julia for you device then come back here.
  - https://github.com/JuliaLang/julia/tree/master/doc/build
  - https://github.com/JuliaCI/julia-buildbot

## Prepare environment

1. Install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

For Ubuntu user, you will need install cross compilation tools:

```
$ apt-get update
$ apt-get install -y qemu-user-static binfmt-support
```

Thats' all

## Try to run Julia

To prove Julia can run on arm devices We've uploaded Docker images on [Docker Hub repository named `jlcross`](https://hub.docker.com/r/terasakisatoshi/jlcross)

- Install docker image from Docker Hub.

```console
$ docker pull terasakisatoshi/jlcross:rpizero-v1.5.3
Unable to find image 'terasakisatoshi/jlcross:rpizero-v1.5.3' locally
rpizero-v1.5.3: Pulling from terasakisatoshi/jlcross
(start to pull image...)

```

- Run Julia script using container

```console
$ cat hello.jl
using Pkg
Pkg.add("Example")
using Example
hello("World")
$ docker run --rm -it -v $PWD:/work -w /work terasakisatoshi/jlcross:rpizero-v1.4.2 julia hello.jl
    Cloning default registries into `~/.julia`
    Cloning registry from "https://github.com/JuliaRegistries/General.git"
      Added registry `General` to `~/.julia/registries/General`
  Resolving package versions...
  Installed Example ─ v0.5.3
   Updating `~/.julia/environments/v1.4/Project.toml`
  [7876af07] + Example v0.5.3
   Updating `~/.julia/environments/v1.4/Manifest.toml`
  [7876af07] + Example v0.5.3
```

## Build Julia on your machine

- If you'd like to build Julia for your Raspberry Pi3, download, for example, `rpi3/Dockerfile-v1.5.3` and run the following command on your terminal to build Docker image which will include Julia binary:

```console
$ docker build -t jl4rpi3 -f Dockerfile-v1.5.3 .
```

- Please be patient, it will take long time (within a half day) to build.
- Also see my gist:
  - [(gist) Build Julia for RaspberryPi Zero](https://gist.github.com/terasakisatoshi/3f8a55391b1fc22a5db4a43da8d92c98)
  - [Cross Compile Julia For RaspberryPi3 using Docker](https://gist.github.com/terasakisatoshi/00fa7d7b81b7c6748f2298f6ff65bf6e)
- Using `docker-compose` will build each version of Julia. Namely:

```console
$ docker-compose build --parallel
```


## Get binary from container


- After building the docker image(or pulling docker image from our Docker Hub repository), you can get Julia binary by copying it from docker container generated by docker image what you've got

### Raspberry Pi Zero

- in this section, you'll know how to get Julia for Raspberry Pi Zero.

```console
# open your terminal e.g. your work station
$ cat get_binary.sh # write shell script by yourself like below:
#!/bin/bash

JL_VERSION=v1.5.3
IMAGE_NAME=terasakisatoshi/jlcross:rpizero-${JL_VERSION}
CONTAINER_NAME=jltmp_${JL_VERSION}
docker run --name ${CONTAINER_NAME} $IMAGE_NAME /bin/bash
docker cp ${CONTAINER_NAME}:/home/pi/julia-${JL_VERSION} .
docker rm ${CONTAINER_NAME}
$ bash get_binary.sh
$ ls
julia-v1.5.3
```

- Copy `julia-v1.5.3` to your Raspberry Pi zero:

```console
$ scp -r julia-v1.5.3 pi@raspberrypi.local:/home/pi
```

- After copying `julia-v1.5.3` to your Raspberry Pi, one need install the following dependencies via `apt` which is almost same as Dockerfile-v1.5.3.

```console
# Open Your Raspberry Pi's terminal
$ sudo apt-get update && \
    sudo apt-get install -y build-essential libatomic1 python gfortran perl wget m4 cmake pkg-config \
    libopenblas-dev \
    liblapack-dev \
    libgmp3-dev \
    libmpfr-dev
$ echo export 'PATH=${HOME}/julia-v1.5.3/bin:${PATH}' >> ~/.bashrc
$ source ~/.bashrc
$ julia # Oh Yes!!!
```

That's all

### Raspberry Pi 3/4

- Similar to Raspberry Zero, have a try

```console
# open your terminal e.g. your work station
$ cat get_binary.sh # write shell script by yourself like below:
#!/bin/bash

JL_VERSION=v1.5.3
IMAGE_NAME=terasakisatoshi/jlcross:rpi3-${JL_VERSION}
CONTAINER_NAME=jltmp_${JL_VERSION}
docker run --name ${CONTAINER_NAME} $IMAGE_NAME /bin/bash
docker cp ${CONTAINER_NAME}:/home/pi/julia-${JL_VERSION} .
docker rm ${CONTAINER_NAME}
$ bash get_binary.sh
$ ls
julia-v1.5.3
```

- You can also build julia `v1.6.0-DEV` by yourself.
  - [See my gist](https://gist.github.com/terasakisatoshi/8a95eb8b676a29ad3f5fe4a717ff3254)
![image](https://user-images.githubusercontent.com/16760547/99070290-4a5fb900-25f3-11eb-8d3b-23c009df7b0d.png)

# Restriction

- We can't confirm building Julia version = `v1.2.0` on Raspberry Pi zero works fine.
  - You'll see some error message with respect to illegal instruction.
  - `v1.0.5`, `v1.1.1`, `v1.3.1`, `v1.4.0`, `v1.4.1`, `v1.4.2`, `v1.5.0-rc1`, `v1.5.0`, `v1.5.1`, `v1.5.2`, `v1.5.3` are O.K.

- To pass building procedure for Julia v1.5.0, we have to modify `contrib/generate_precompile.jl` script that omit precompile statements regarding to `Pkg` installation to avoid this issue [armv7l: ptrtoint not supported for non-integral pointers #36062](https://github.com/JuliaLang/julia/issues/36062). This modification will increase the latency for users to install arbitrary packages. If you are new to Julia and want to try it on your Raspberry Pi, we strongly recommend to use julia `v1.4.2` or `v1.5.2` not `v1.5.0`. 

- We can't build Julia version = `v1.2.0` on Raspberry Pi3 using Docker its base image is `balenalib/raspberrypi3:buster-20191030` with error message something like:
  - ` undefined reference to llvm::BasicBlockPass::createPrinterPass(llvm::raw_ostream&, std::string const&) const'`


# References

- [Docker](https://www.docker.com/)
- [Docker Machine](https://docs.docker.com/machine/)
- [The easy way to set up Docker on a Raspberry Pi](https://medium.freecodecamp.org/the-easy-way-to-set-up-docker-on-a-raspberry-pi-7d24ced073ef)
- [How to install Docker on your Raspberry Pi](https://howchoo.com/g/nmrlzmq1ymn/how-to-install-docker-on-your-raspberry-pi)
- [Happy Pi Day with Docker and Raspberry Pi](https://blog.docker.com/2019/03/happy-pi-day-docker-raspberry-pi/)
- [Base Image List](https://www.balena.io/docs/reference/base-images/base-images-ref/)
- [multiarch/crossbuild](https://github.com/multiarch/crossbuild)

# References (Japanese blog)

- [Julia 1.1.0 をソースからビルドして RaspberryPi Zeroシリーズ や 3B+ とかで使いたいんじゃが？（Dockerでクロスコンパイルでどうじゃろ？）](https://qiita.com/SatoshiTerasaki/items/00f6bc2428ef81999164)
- [x86_64のUbuntuでC/C++のソースコードをARM/ARM64用にクロスコンパイルしてQEMUで実行する方法のまとめ](https://qiita.com/tetsu_koba/items/9bdcb59f912efbff3128)
- [ラズパイ向けのOpenCVを、x86_64機のDockerでビルド](https://qiita.com/mt08/items/51a2187076ddca0db7b0)
- [Jetson 上で Docker イメージをビルドするのが辛かったので EC2 上にビルド環境を作った](https://tech-blog.abeja.asia/entry/environment-of-building-docker-image-for-jetson)

# License

- As with all Dockerfiles, how to build julia, are licensed under the terms of MIT License.

- As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

  - Some additional license information which was able to be auto-detected might be found in [the repo-info repository's julia/ directory](https://github.com/docker-library/repo-info/tree/master/repos/julia).

  - As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
