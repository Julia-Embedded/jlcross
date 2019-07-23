# Build Julia from source on MacOSX

I've confirmed my Mac machine succeeded to build Julia from source at master (2019/07/23)　

# create env

```console
$ brew list > mylist.txt
$ cat mylist.txt | xargs brew install
```

This technique is taken from [the issue](https://github.com/Homebrew/legacy-homebrew/issues/45003)

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
