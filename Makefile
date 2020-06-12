# No make special variables or rules used in order to be most easily understood

ALL = use_directly use_wrapper

PROG = bin/use_directly bin/use_wrapper

# These two are broken out so that they may be overridden on the command line for testing.
# i.e. show original error with "make LIB_RTL= USE_RTL= clean test"
LIB_RTL = lib/libnimrtl.so
USE_RTL = -d:useNimRtl

LIBS = ${LIB_RTL} lib/library.so 

# ADDTL_OPT may be used to show how --opt:none results in error.
# i.e. the use_wrapper test fails with "make ADDTL_OPT=--opt:none clean test"
COMMON_OPTIONS = --threads:on ${ADDTL_OPT}

NIM_OPTIONS = ${USE_RTL} ${COMMON_OPTIONS}


all : ${PROG}
	@ echo

test : ${ALL}
	@ echo


direct : use_directly
	@ echo

wrapped : use_wrapper
	@ echo


use_directly : bin/use_directly
	@ echo
	export LD_LIBRARY_PATH=$$( realpath lib ) && bin/use_directly

use_wrapper : bin/use_wrapper
	@ echo
	export LD_LIBRARY_PATH=$$( realpath lib ) && bin/use_wrapper


bin/use_directly : ${LIBS}
	@ echo
	mkdir -p bin && nim c --app:console ${NIM_OPTIONS} --out:bin/use_directly use_directly.nim

bin/use_wrapper : ${LIBS}
	@ echo
	mkdir -p bin && nim c --app:console ${NIM_OPTIONS} --out:bin/use_wrapper use_wrapper.nim


lib/library.so :
	@ echo
	mkdir -p lib && nim c --app:lib ${NIM_OPTIONS} --out:lib/library.so library.nim

lib/libnimrtl.so :
	@ echo
	mkdir -p lib && nim c --app:lib ${COMMON_OPTIONS} -d:createNimRtl -d:release '--warning[UnusedImport]:off' --out:lib/libnimrtl.so nimrtl.nim


clean :
	@ echo
	rm -rf bin lib
	@ echo
