NPROCS:=1
OS:=$(shell uname -s)

ifeq ($(OS),Linux)
  NPROCS:=$(shell grep -c ^processor /proc/cpuinfo)
endif
ifeq ($(OS),Darwin) # Assume Mac OS X
  NPROCS:=$(shell getconf _NPROCESSORS_ONLN)
endif

OWNER=JuliaLang
REPOSITORY=julia

all: build

clone:
ifeq ($(wildcard ./$(REPOSITORY)/.),)
	git clone https://github.com/$(OWNER)/$(REPOSITORY).git
else
	@echo "already exists"
endif

build: clone
	echo "prefix=$(HOME)/julia_dev" > Make.user
	echo "USE_BINARYBUILDER=0" >> Make.user
	mv Make.user ./julia/Make.user
	make -C julia -j $(NPROCS) 1>build_log.txt 2>build_error.txt

install: build
	sudo make -C julia install 1>install_log.txt 2>install_error.txt

clean:
	rm -f build_log.txt
	rm -f build_error.txt

cleanall:
	rm -f build_log.txt
	rm -f build_error.txt
	sudo rm -rf julia

