# Build Julia from source on MacOSX/Ubuntu

# Feature

- We've confirmed my Mac machine succeeded to build Julia from source at master (2020/08/15)

```julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.6.0-DEV.646 (2020-08-15)
 _/ |\__'_|_|_|\__'_|  |  Commit d47f7d0827 (1 day old master)
|__/                   |           |
```

- We've confirmed our `Makefile` works fine On my Ubuntu 16.04 PC

# Build

```
$ cd path/to/this/README.md
$ make
# just wait
```

# Install

```
$ make install # you may need to add `sudo`
```

- It will create directory named `~/julia_dev`.
- You can call the latest julia via `~/julia_dev/bin/julia`
- Or simply set alias on `~/.bash_profile` for example :
```
alias jldev="$HOME/julia_dev/bin/julia"
```

# Clean up

```
make reset
```

# References

- [julia/doc/build](https://github.com/JuliaLang/julia/tree/master/doc/build)
- [How can I write a makefile to auto-detect and parallelize the build with GNU Make?
](https://stackoverflow.com/questions/2527496/how-can-i-write-a-makefile-to-auto-detect-and-parallelize-the-build-with-gnu-mak)
- [Conditionals in Makefile: missing separator error?
](https://stackoverflow.com/questions/16770042/conditionals-in-makefile-missing-separator-error)
