## fio.apl

GNU APL ⎕FIO abstraction library.

## Synopsis

TL;DR - ⎕FIO is too low-level IMO for use in APL and this library is my
highly-biased reimagining of it.

See the library file `fio.apl` for more details.

In GNU APL, interations with the operating system (file handling, spawning
processes, opening ports, etc.) are done with ⎕FIO. However, I find that there
are several problems with it.

Prior to version GNU APL 1.9, ⎕FIO functions were specified with an axis
argument, i.e.  ⎕FIO[3] (fopen,) which lead to code that was hard to read. Now
you can specify them by name, i.e. ⎕FIO['fopen'] or ⎕FIO.fopen. This is the
reason I orignally developed this library, but there are still other things for
which I think this library has value.

The ⎕FIO functions are replicas of C functions, whose error handling methods
vary considerably between functions. This is fine in C, but APL is far more
abstract than C with a completely different way to represent logic. This library
provides, what I consider, to be a more consistent and sensible error handling
scheme through the use of a vector that replicates the errorable data types from
other languages, like error unions in Zig and Either in Haskell.

Many of the functions that handle file descriptors throw an exception on an
unopened file descriptor, instead of returning some kind of error code. I think
that this is kind of weird, and I have replaced it with the aforementioned error
handling.

Some of the functions are also annoying to use. For example, ⎕FIO[20], mkdir,
requires the file permissions to be converted from octal to decimal numbers
before calling. Functions such as these are given a more user-friendly
interface.

Additionally, this library provides a number of extra functions you will
probably like, such as recursively creating and deleting directories.

Note: functions have been added as-needed, so it will not cover everything in
⎕FIO.

## How to test

Dependencies:

- GNU APL: ([https://www.gnu.org/software/apl](https://www.gnu.org/software/apl))

There is a `flake.nix` you can use with `nix develop` to generate a development
enviroment.

Then, run one of the following commands:

```sh
apl --script test.apl
./test.apl
```
