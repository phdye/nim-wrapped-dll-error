
{.passL: "-Llib -lrary" }

proc lib_foo ( ) {. importc, nodecl, dynlib: "library.so" .}

proc foo* () {.exportc, cdecl, dynlib.} =
  echo "wrapper.foo() - enter"
  lib_foo()
  echo "wrapper.foo() - exit"

#
