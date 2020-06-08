proc lib_foo() {.importc, dynlib: "library.so".}
echo "usage/direct - enter"
lib_foo()
echo "usage/direct - exit"
