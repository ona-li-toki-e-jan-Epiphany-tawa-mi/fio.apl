## fio.apl

In GnuAPL, interations with the operating system (file handling, spawning
processes, opening ports, etc.) are done with ⎕FIO.

The problem is that the specific command in ⎕FIO is specified with an axis
argument (i.e. ⎕FIO[3],) which results in hard-to-read code. Additionally,
some of the functions are also annoying to use (i.e. ⎕FIO[20], mkdir, requires
the file permissions to be converted from octal to decimal numbers before
calling.)

This library provides a small layer of abstraction to give proper names to the
functions provided by ⎕FIO, and some extra utlities that go along with it.

Note: functions have been added as-needed, so it will not cover everything in
⍝ ⎕FIO.

## How to use.

Simply include it into your project on one of the library search paths (run
`)LIBS` to see them,) and use `)COPY <filename>` or `)COPY_ONCE <filename>` to
load it.

If the inclusion of `)COPY` and `)COPY_ONCE` in scripts results in weird text
output, replace the command with something along the lines of the following:

```apl
⊣ ⍎")COPY <file>"
```
