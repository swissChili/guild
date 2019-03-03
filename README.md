# guild - a modern makefile generator

Guild is a makefile generator - vaguelly similar to CMake in functionality,
but with simplicity at its forefront. Guild has likely the simplest syntax
of any build tool, having only 2 syntax rules (by the time this is finished
it will probably be closer to 5 but still). You can learn guild in about 30
seconds if you have a basic understanding of programming or makefiles.

## syntax

Guild is a declarative language. It describes the relationships between files
\- not how to create them. This example demonstrates the simplest build script
possible, which compiles a program `main.c` into the binary `main`:
```
main.c -> main
```
This script describes the relationship between the two files `main.c` and `main`.
It states that `main.c` is used to create `main`. Note that it does not at all
describe *how* this is to be done: guild will attempt to figure this out for you.

More complex build scripts are of course also possible. Here is a slightly more
complicated one that relies on a statically linked library:
```
main.c, main.h, foo.h, libfoo.a -> main
foo.c, foo.h -> foo.o
foo.o -> libfoo.a
```
