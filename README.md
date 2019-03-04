# guild - a modern makefile generator

![Circle CI](https://img.shields.io/circleci/project/github/swissChili/guild.svg)

Guild is a makefile generator - vaguelly similar to CMake in functionality,
but with simplicity at its forefront. Guild has likely the simplest syntax
of any build tool, having only 4 syntax rules. You can learn guild in about 30
seconds if you have a basic understanding of programming or makefiles.

## syntax

### recipes

Guild is a declarative language. It describes the relationships between files
\- not how to create them. This example demonstrates the simplest build script
possible, which compiles a program `main.c` into the binary `main`:
```
main.c -> main
```
This script describes the relationship between the two files `main.c` and `main`.
It states that `main.c` is used to create `main`. Note that it does not at all
describe *how* this is to be done: guild will attempt to figure this out for you.

### source types

More complex build scripts are of course also possible. Here is a slightly more
complicated one that relies on a statically linked library:
```
main.c, main.h, foo.h, libfoo.a -> main (c)
foo.c, foo.h -> foo.o (c)
foo.o -> libfoo.a
```
As you may notice, `(c)` is used to tell Guild that the sources should be treated
as C files. Currently `c` and `c++` are supported.

### variables

Variables in guild work pretty much how you'd expect. A name is followed by an 
equal sign (`=`) and a value. These map to variables in the generated Makefile.
There are several variables that are defined automatically by guild. These can
be overwritten by setting them in a guildfile. 
```
CC = gcc
CFLAGS = -Wall -O3
```
Here are the variables defined by Guild for you:
- CC (cc): Command to use to compile C files
- CPPC (c++): Command to use to compile C++ files
- AR (ar): Command used to create archives (.a)
- CFLAGS (-Wall): Arguments given to the C compiler
- CPPFLAGS (-Wall): Arguments given to the C++ compiler

### comments

Comments are marked by a `#` character and span to the end of the line. There are no
multi-line comments. These comments will be included in the generated makefile and can
aid in readability.
```
# This is a comment
```
