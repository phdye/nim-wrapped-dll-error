proc lib_foo* () {.exportc, dynlib.} =
  echo "library.foo() - enter"
  var spc : string = " "  
  echo "library.foo() - exit"
