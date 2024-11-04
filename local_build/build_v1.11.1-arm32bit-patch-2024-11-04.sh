#! /bin/bash

# MIT License
#
# Copyright (c) 2024 Satoshi Terasaki <terasakisatoshi.math@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Usage:
# 1. Copy this file to your raspberry pi e.g. /home/pi
# 2. Run this file `bash build_v1.11.1-arm32bit-patch-2024-11-04.sh`

# This script is tested on the following cases:
# Case 1:
# Operating System: Raspberry Pi OS Lite (32-bit)
# Device: Raspberry Pi 4 with 4 GB RAM

# Case 2:
# Operating System: Raspberry Pi OS Lite (32-bit)
# Device: Raspberry Pi 4 with 8 GB RAM

# Case 3 (preferred):
# Operating System: Raspberry Pi OS Lite (32-bit)
# Device: Raspberry Pi 5 with 8 GB RAM

# Need to increase the swap file size. To do so, edit /etc/dphys-swapfile
sudo sed -i 's/^CONF_SWAPSIZE=200/#&/; s/^#CONF_SWAPSIZE=2048/CONF_SWAPSIZE=2048/' \
     /etc/dphys-swapfile

sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

sudo apt-get update && sudo apt-get install -y \
    build-essential libatomic1 python3 gfortran perl wget m4 cmake pkg-config zlib1g-dev \
    git unzip nano \
    libopenlibm-dev

REPOSITORY_OWNER=terasakisatoshi
JL_VERSION=terasaki/v1.11.1-arm32bit-patch-2024-11-04
JL_BUILD_DIR=build-julia-${JL_VERSION}
git clone --depth 1 -b ${JL_VERSION} https://github.com/${REPOSITORY_OWNER}/julia.git $JL_BUILD_DIR

cat > ${JL_BUILD_DIR}/Make.user << EOF
USE_BINARYBUILDER=1
prefix=${HOME}/${JL_VERSION}
CFLAGS += -mfpu=neon-vfpv4
CFLAGS += -mfloat-abi=hard
CXXFLAGS += -mfpu=neon-vfpv4
CXXFLAGS += -mfloat-abi=hard
USE_SYSTEM_OPENLIBM=1
USE_SYSTEM_CSL=1
MARCH=armv7-a+fp
EOF

# You can change the number of threads to reduce RAM consumption
# e.g., make -j 2 on Raspberry Pi 4 with 4GB RAM
# By default, it uses all available threads
# During compilation there are some warnings, e.g., 'armv7-a+fp' is not a recognized processor for this target (ignoring processor)
# You can ignore them.
cd ${JL_BUILD_DIR} && make -j && sudo make install && cd ..

${HOME}/${JL_VERSION}/bin/julia -e 'using InteractiveUtils; versioninfo()'
echo "Installation of Julia is completed."
echo "Please add ${HOME}/${JL_VERSION}/bin to your PATH."
echo "You can do so by adding the following line to your ~/.bashrc:"
echo "export PATH=\$PATH:${HOME}/${JL_VERSION}/bin"
