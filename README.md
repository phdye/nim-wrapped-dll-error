```
$ make test

mkdir -p lib && nim compile --app:lib --threads:off --opt:none --out:lib/library.so library.nim

mkdir -p bin && nim compile --app:console --threads:off --opt:none --out:bin/use_directly use_directly.nim

export LD_LIBRARY_PATH=$( realpath lib ) && bin/use_directly
usage/direct - enter
library.foo() - enter
library.foo() - exit
usage/direct - exit

mkdir -p bin && nim compile --app:console --threads:off --opt:none --out:bin/use_wrapper use_wrapper.nim

export LD_LIBRARY_PATH=$( realpath lib ) && bin/use_wrapper
usage/wrapped - enter
wrapper.foo() - enter
library.foo() - enter
Traceback (most recent call last)
/home/phdyex/src/nim/error/nim-wrapped-dll-error/use_wrapper.nim(3) use_wrapper
/home/phdyex/src/nim/error/nim-wrapped-dll-error/wrapper.nim(8) foo
SIGSEGV: Illegal storage access. (Attempt to read from nil?)
Makefile:20: recipe for target 'use_wrapper' failed
make: *** [use_wrapper] Error 1
```
