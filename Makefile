# No make special variables used in order to be most easily understood

ALL = use_directly use_wrapper

PROG = bin/use_directly bin/use_wrapper

LIB = lib/library.so


all : ${PROG}

test : ${ALL}


use_directly : bin/use_directly
	export LD_LIBRARY_PATH=$$( realpath lib ) && bin/use_directly

use_wrapper : bin/use_wrapper
	export LD_LIBRARY_PATH=$$( realpath lib ) && bin/use_wrapper


bin/use_directly : ${LIB}
	mkdir -p bin && nim compile --app:console --threads:off --opt:none --out:bin/use_directly use_directly.nim

bin/use_wrapper : ${LIB}
	mkdir -p bin && nim compile --app:console --threads:off --opt:none --out:bin/use_wrapper use_wrapper.nim


lib/library.so :
	mkdir -p lib && nim compile --app:lib --threads:off --opt:none --out:lib/library.so library.nim

clean :
	rm -rf bin lib
