# Build Julia from source on MacOSX

I've confirmed my Mac machine succeeded to build Julia from source at master (2019/07/23)
- Commit f2513a8ca6

# create env

```console
$ brew list > mylist.txt
$ cat mylist.txt | xargs brew install
```

This technique is taken from [the issue](https://github.com/Homebrew/legacy-homebrew/issues/45003)

- Note that `mylist.txt` contain some Redundancy. You do not have to follow this method.


# build

```
$ make clone
$ make build
$ make install
```

# clean

```
$ make clean
# or
$ make cleanall
```

```julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.3.0-alpha.1 (2019-07-23)
 _/ |\__'_|_|_|\__'_|  |  Commit f2513a8ca6 (0 days old master)
|__/                   |
```