NPROCS:=1
OS:=$(shell uname -s)

ifeq ($(OS),Linux)
  NPROCS:=$(shell grep -c ^processor /proc/cpuinfo)
endif
ifeq ($(OS),Darwin) # Assume Mac OS X
  NPROCS:=$(shell getconf _NPROCESSORS_ONLN)
endif

OWNER:=JuliaLang
REPOSITORY:=julia
BRANCH:=master

all: build

clone:
ifeq ($(wildcard ./$(REPOSITORY)/.),)
	git clone --depth=1 -b $(BRANCH) https://github.com/$(OWNER)/$(REPOSITORY).git
else
	@echo "already exists"
endif

build: clone
	echo "prefix=$(HOME)/julia_dev" > Make.user
	echo "USE_BINARYBUILDER = 0" >> Make.user
	mv Make.user ./julia/Make.user
	make -C julia -j $(NPROCS) 1>build_log.txt 2>build_error.txt

# brew install openblas
# brew info openblas
# ... do we need ?
# export PKG_CONFIG_PATH="/usr/local/opt/openblas/lib/pkgconfig"
# export LDFLAGS="-L/usr/local/opt/openblas/lib"
# export CPPFLAGS="-I/usr/local/opt/openblas/include"
build_system_blas: clone
	echo "prefix=$(HOME)/julia_dev" > Make.user
	echo "USE_SYSTEM_BLAS=1" >> Make.user
	mv Make.user ./julia/Make.user
	make -C julia -j $(NPROCS) 1>build_log.txt 2>build_error.txt

# source /opt/intel/bin/compilervars.sh intel64
build_mkl: clone
	echo "prefix=$(HOME)/julia_dev" > Make.user
	echo "USEICC = 0" >> Make.user
	echo "USEIFC = 0" >> Make.user
	echo "USE_INTEL_MKL = 1" >> Make.user
	echo "USE_INTEL_LIBM = 0" >> Make.user
	echo "USE_BINARYBUILDER = 0" >> Make.user
	$(shell source /opt/intel/bin/compilervars.sh intel64)
	mv Make.user ./julia/Make.user
	make -C julia -j $(NPROCS) 1>build_log.txt 2>build_error.txt

install:
	sudo make -C julia install 1>install_log.txt 2>install_error.txt

clean:
	rm -f build_log.txt
	rm -f build_error.txt
	rm -f install_log.txt
	rm -f install_error.txt
ifneq ($(wildcard ./$(REPOSITORY)/.),)
	make -C julia clean
endif

reset:
	rm -f build_log.txt
	rm -f build_error.txt
	sudo rm -rf julia
