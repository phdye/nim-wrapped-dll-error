Seems to be the same issue as [Trouble using dynamic libraries in Nim](https://forum.nim-lang.org/t/4029).

And, yes, once modified to use a single GC via the NIM Runtime Library, use_wrapped executes correctly.

I'll leave this up in case it proves useful to anyone researching the same or similar issue.

### Using NIM's RTL -d:useNimRtl it works.  **CAVEAT**: don't use --opt:none (see below)

```
rm -rf bin lib


mkdir -p lib && nim c --app:lib --threads:on  -d:createNimRtl -d:release '--warning[UnusedImport]:off' --out:lib/libnimrtl.so nimrtl.nim

mkdir -p lib && nim c --app:lib -d:useNimRtl --threads:on  --out:lib/library.so library.nim

mkdir -p bin && nim c --app:console -d:useNimRtl --threads:on  --out:bin/use_directly use_directly.nim

export LD_LIBRARY_PATH=$( realpath lib ) && bin/use_directly
usage/direct - enter
library.foo() - enter
library.foo() - exit
usage/direct - exit

mkdir -p bin && nim c --app:console -d:useNimRtl --threads:on  --out:bin/use_wrapper use_wrapper.nim

export LD_LIBRARY_PATH=$( realpath lib ) && bin/use_wrapper
usage/wrapped - enter
wrapper.foo() - enter
library.foo() - enter
library.foo() - exit
wrapper.foo() - exit
usage/wrapped - exit
usage/wrapped - enter
wrapper.foo() - enter
library.foo() - enter
library.foo() - exit
wrapper.foo() - exit
usage/wrapped - exit

```

### Fails with RTL when --opt:none specified
```
rm -rf bin lib


mkdir -p lib && nim c --app:lib --threads:on --opt:none -d:createNimRtl -d:release '--warning[UnusedImport]:off' --out:lib/libnimrtl.so nimrtl.nim

mkdir -p lib && nim c --app:lib -d:useNimRtl --threads:on --opt:none --out:lib/library.so library.nim

mkdir -p bin && nim c --app:console -d:useNimRtl --threads:on --opt:none --out:bin/use_directly use_directly.nim

export LD_LIBRARY_PATH=$( realpath lib ) && bin/use_directly
usage/direct - enter
library.foo() - enter
library.foo() - exit
usage/direct - exit

mkdir -p bin && nim c --app:console -d:useNimRtl --threads:on --opt:none --out:bin/use_wrapper use_wrapper.nim

export LD_LIBRARY_PATH=$( realpath lib ) && bin/use_wrapper
usage/wrapped - enter
wrapper.foo() - enter
library.foo() - enter
Segmentation fault (core dumped)
Makefile:40: recipe for target 'use_wrapper' failed
make: *** [use_wrapper] Error 139
```

### Before Fix

```
rm -rf bin lib


mkdir -p lib && nim c --app:lib  --threads:on  --out:lib/library.so library.nim

mkdir -p bin && nim c --app:console  --threads:on  --out:bin/use_directly use_directly.nim

export LD_LIBRARY_PATH=$( realpath lib ) && bin/use_directly
usage/direct - enter
library.foo() - enter
library.foo() - exit
usage/direct - exit

mkdir -p bin && nim c --app:console  --threads:on  --out:bin/use_wrapper use_wrapper.nim

export LD_LIBRARY_PATH=$( realpath lib ) && bin/use_wrapper
usage/wrapped - enter
wrapper.foo() - enter
library.foo() - enter
Traceback (most recent call last)
/home/phdyex/src/nim/error/nim-wrapped-dll-error/use_wrapper.nim(3) use_wrapper
/home/phdyex/src/nim/error/nim-wrapped-dll-error/wrapper.nim(8) foo
SIGSEGV: Illegal storage access. (Attempt to read from nil?)
Makefile:40: recipe for target 'use_wrapper' failed
make: *** [use_wrapper] Error 1
```
