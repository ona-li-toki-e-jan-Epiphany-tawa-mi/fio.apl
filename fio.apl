⍝!/usr/local/bin/apl --script

⍝ This file is part of fio.apl.
⍝
⍝ Copyright (c) 2024 ona-li-toki-e-jan-Epiphany-tawa-mi
⍝
⍝ fio.apl is free software: you can redistribute it and/or modify it under the
⍝ terms of the GNU General Public License as published by the Free Software
⍝ Foundation, either version 3 of the License, or (at your option) any later
⍝ version.
⍝
⍝ fio.apl is distributed in the hope that it will be useful, but WITHOUT ANY
⍝ WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
⍝ A PARTICULAR PURPOSE. See the GNU General Public License for more details.
⍝
⍝ You should have received a copy of the GNU General Public License along with
⍝ fio.apl. If not, see <https://www.gnu.org/licenses/>.

⍝ fio.apl GnuAPL ⎕FIO abstraction library.
⍝
⍝ SYNOPSIS:
⍝   In GnuAPL, interations with the operating system (file handling, spawning
⍝   processes, opening ports, etc.) are done with ⎕FIO.
⍝
⍝   The problem is that the specific command in ⎕FIO is specified with an axis
⍝   argument (i.e. ⎕FIO[3],) which results in hard-to-read code. Additionally,
⍝   some of the functions are also annoying to use (i.e. ⎕FIO[20], mkdir,
⍝   requires the file permissions to be converted from octal to decimal numbers
⍝   before calling.)
⍝
⍝   This library provides a small layer of abstraction to give proper names to
⍝   the functions provided by ⎕FIO, and some extra utlities that go along with
⍝   it.
⍝
⍝   Note: functions have been added as-needed, so it will not cover everything
⍝   in ⎕FIO.
⍝
⍝ USAGE:
⍝   Simply include it into your project on one of the library search paths (run
⍝   ')LIBS' to see them,) and use ')COPY_ONCE fio.apl' to load it.
⍝
⍝   If the inclusion of ')COPY_ONCE' in scripts results in weird text output,
⍝   replace the command with '⊣ ⍎")COPY_ONCE fio.apl"'.
⍝
⍝ Changelog:
⍝ - Upcoming:
⍝   - Relicensed as GPLv3+ (orignally zlib.)
⍝   - Code cleanup. A number of functions have changed, audit your code.
⍝   - Added FIO∆PERROR, FIO∆LIST_FDS, FIO∆STRERROR, FIO∆ERRNO, FIO∆FGETS,
⍝     FIO∆FGETC, FIO∆UNLINK, FIO∆RMDIR, FIO∆FPRINTF, FIO∆GETCWD.
⍝   - Split FIO∆GET_TIME_OF_DAY into seperate functions.
⍝   - Verified behavior with unit testing.
⍝ - 0.1.0:
⍝   - Intial release.

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Metadata                                                                     ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ See <https://www.gnu.org/software/apl/Library-Guidelines-GNU-APL.html> for
⍝ details.
FIO⍙metadata←"Author" "BugEmail" "Documentation" "Download" "LICENSE" "Portability" "Provides" "Requires" "Version",⍪"ona li toki e jan Epiphany tawa mi" "" "https://paltepuk.xyz/cgit/fio.apl.git/about/" "https://paltepuk.xyz/cgit/fio.apl.git/plain/fio.apl" "GPLv3+" "L3" "FIO" "" "0.1.0"

⍝ Links:
⍝ - paltepuk - https://http://paltepuk.xyz/cgit/fio.apl.git/about/
⍝ - paltepuk (I2P) - http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p/cgit/fio.apl.git/about/
⍝ - paltepuk (Tor) - http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion/cgit/fio.apl.git/about/
⍝ - GitHub - https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/fio.apl/

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Constants                                                                    ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Common file descriptors.
FIO∆STDIN←0
FIO∆STDOUT←1
FIO∆STDERR←2

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ ⎕FIO Wrappers                                                                ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Returns a number vector of open file descriptors.
⍝ From '' ⎕FIO[0] '': ⎕FIO     0     return a list of open file descriptors
∇FDS←FIO∆LIST_FDS
  FDS←⎕FIO 0
∇

⍝ Returns the value of ERRNO for the previous ⎕FIO-C function.
⍝ From '' ⎕FIO[0] '': Zi ←    ⎕FIO[ 1] ''    errno (of last call)
∇ERRNO←FIO∆ERRNO
  ERRNO←⎕FIO[1] ''
∇

⍝ Returns a byte vector describing the provided ERRNO.
⍝ From '' ⎕FIO[0] '': Zs ←    ⎕FIO[ 2] Be    strerror(Be)
∇BYTES←FIO∆STRERROR ERRNO
  ⍝ ⎕FIO[2] actually returns a character vector of the bytes, so ⎕UCS is used to
  ⍝ convert them to numbers.
  BYTES←⎕UCS (⎕FIO[2] ERRNO)
∇

⍝ Opens a file with fopen.
⍝ MODE - open mode (i.e. "w", "r+", etc..)
⍝ FD - the file descriptor, or a scalar number less than 1 on failure.
⍝ From '' ⎕FIO[0] '': Zh ← As ⎕FIO[ 3] Bs    fopen(Bs, As) filename Bs mode As
∇FD←MODE FIO∆FOPEN PATH
  FD←MODE ⎕FIO[3] PATH
∇

⍝ Closes a file descriptor.
⍝ ERROR - 0, if successful.
⍝ From '' ⎕FIO[0] '': Ze ←    ⎕FIO[ 4] Bh    fclose(Bh)
∇ERROR←FIO∆FCLOSE FD
  ERROR←⎕FIO[4] FD
∇

⍝ Reads bytes up to specified number of bytes from the file descriptor.
⍝ BYTES - The data read, as a byte vector, or a scalar 0, if there was an error
⍝         or EOF was reached.
⍝ From '' ⎕FIO[0] '': Zb ← Ai ⎕FIO[ 6] Bh    fread(Zi, 1, Ai, Bh) 1 byte per Zb
∇BYTES←MAXIMUM_BYTES FIO∆FREAD FD
  BYTES←MAXIMUM_BYTES ⎕FIO[6] FD
∇

⍝ Writes a byte vector to the file descriptor.
⍝ BYTES_WRITTEN -The number of bytes written.
⍝ From '' ⎕FIO[0] '': Zi ← Ab ⎕FIO[ 7] Bh    fwrite(Ab, 1, ⍴Ai, Bh) 1 byte per Ai
∇BYTES_WRITTEN←BYTES FIO∆FWRITE FD
  BYTES_WRITTEN←BYTES ⎕FIO[7] FD
∇

⍝ Reads bytes to a newline or up to a specified number of bytes from the file
⍝ descriptor. Newlines are included in the output.
⍝ BYTES - The data read, as a byte vector, or a scalar 0, if there was an error
⍝         or EOF was reached.
⍝ From '' ⎕FIO[0] '': Zb ← Ai ⎕FIO[ 8] Bh    fgets(Zb, Ai, Bh) 1 byte per Zb
∇BYTES←MAXIMUM_BYTES FIO∆FGETS FD
  BYTES←MAXIMUM_BYTES ⎕FIO[8] FD

  →(⍬≢BYTES) ⍴ LSUCCESS
    BYTES←0
  LSUCCESS:
∇

⍝ Reads one byte from the file descriptor, or a scalar 0, if there was an error
⍝ or EOF.
⍝ From '' ⎕FIO[0] '': Zb ←    ⎕FIO[ 9] Bh    fgetc(Zb, Bh) 1 byte
∇BYTE←FIO∆FGETC FD
  BYTE←⎕FIO[9] FD
∇

⍝ Returns a non-zero scalar number if EOF was reached for the file descriptor.
⍝ From ⎕FIO: '': Zi ←    ⎕FIO[10] Bh    feof(Bh)
∇EOF_REACHED←FIO∆FEOF FD
  EOF_REACHED←⎕FIO[10] FD
∇

⍝ Returns a non-zero scalar number if an error ocurred with the file
⍝ descriptor.
⍝ From ⎕FIO: '':  Ze ←    ⎕FIO[11] Bh    ferror(Bh)
∇HAS_ERROR←FIO∆FERROR FD
  HAS_ERROR←⎕FIO[11] FD
∇

⍝ TODO FIO[12] - ftell
⍝ TODO FIO[13,14,15] - fseek
⍝ TODO FIO[16] - fflush.
⍝ TODO FIO[17] - fsync.
⍝ TODO FIO[18] - fstat.

⍝ Unlinks a file at the given path, possibly deleting it.
⍝ ERROR - a non-zero scalar number if an error ocurred.
⍝ From '' ⎕FIO[0] '': Zi ←    ⎕FIO[19] Bh    unlink(Bc)
∇ERROR←FIO∆UNLINK PATH
  ERROR←⎕FIO[19] PATH
∇

⍝ Creates a directory at the given path if it doesn't exist. Does not recurse.
⍝ MODE - octal mode for the directory as an integer vector (i.e. 0 7 5 5.)
⍝ ERROR - a non-zero scalar number if an error occured.
⍝ From '' ⎕FIO[0] '': Zi ← Ai ⎕FIO[20] Bh    mkdir(Bc, AI)
∇ERROR←MODE FIO∆MKDIR PATH
  ERROR←PATH ⎕FIO[20]⍨ 8⊥MODE
∇

⍝ Deletes the directory at the given path.
⍝ ERROR - a non-zero scalar number if an error occured.
⍝ From '' ⎕FIO[0] '': Zi ←    ⎕FIO[21] Bh    rmdir(Bc)
∇ERROR←FIO∆RMDIR PATH
  ERROR←⎕FIO[21] PATH
∇

⍝ Prints formatted output to a file descriptor, like C fprintf.
⍝ FORMAT_ARGUMENTS - a vector containing the format as the first element, and
⍝                    the arguments being the remaining elements.
⍝ BYTES_WRITTEN - the number of bytes written, or a scalar negative number, if
⍝                 an error ocurred.
⍝ From '' ⎕FIO[0] '': Zi ← A  ⎕FIO[22] Bh    fprintf(Bh,     A1, A2...) format A1
∇BYTES_WRITTEN←FORMAT_ARGUMENTS FIO∆FPRINTF FD
  BYTES_WRITTEN←FORMAT_ARGUMENTS ⎕FIO[22] FD
∇

⍝ From '' ⎕FIO[0] '': Zh ← As ⎕FIO[24] Bs    popen(Bs, As) command Bs mode As
⍝ Starts the given command in a subprocess.
⍝ FD - the process' read-only file descriptor, or a scalar 0 on failure.
∇FD←FIO∆POPEN_READ COMMAND
  FD←"r" ⎕FIO[24] COMMAND
∇
⍝ TODO add unit test
⍝ Starts the given command in a subprocess.
⍝ FD - The process' write-only file descriptor, or a scalar 0 on failure.
∇FD←FIO∆POPEN_WRITE COMMAND
  FD←"w" ⎕FIO[24] COMMAND
∇

⍝ Closes a file descripter opened with FIO∆POPEN_READ.
⍝ ERPOR - process exit code, or probably a scalar ¯1 on failure.
⍝ From '' ⎕FIO[0] '': Ze ←    ⎕FIO[25] Bh    pclose(Bh)
∇ERROR←FIO∆PCLOSE FD
  ERROR←⎕FIO[25] FD
∇

⍝ Reads in the entirety of the file at the given path as a byte vector.
⍝ BYTE_VECTOR← - The byte vector, or a scalar 0 on failure.
⍝ From '' ⎕FIO[0] '': Zb ←    ⎕FIO[26] Bs    return entire file Bs as byte vector
∇BYTES←FIO∆READ_ENTIRE_FILE PATH
  BYTES←⎕FIO[26] PATH

  →(¯2≢BYTES) ⍴ LSUCCESS
    BYTES←0 ◊ →LERROR
  LSUCCESS:
    ⍝ ⎕FIO[26] actually returns a character vector of the bytes, so ⎕UCS is used
    ⍝ to convert them to numbers.
    BYTES←⎕UCS BYTES
  LERROR:
∇

⍝ TODO ⎕FIO[27] rename file.

⍝ Returns a vector of character vectors with the contents of the directory at
⍝ the given path, or a scalar 0 on error.
⍝ From '' ⎕FIO[0] '': Zn ←    ⎕FIO[29] Bs    return file names in directory Bs
∇CONTENTS←FIO∆LIST_DIRECTORY PATH
  CONTENTS←⎕FIO[29] PATH

  →(¯2≢CONTENTS) ⍴ LSUCCESS
    CONTENTS←0
  LSUCCESS:
∇

⍝ Returns the current working directory.
⍝ Probably returns 0 on error.
⍝ From '' ⎕FIO[0] '': Zs ←    ⎕FIO 30        getcwd()
∇DIRECTORY←FIO∆GETCWD
  DIRECTORY←⎕FIO 30
∇

⍝ TODO ⎕FIO[31] access
⍝ TODO ⎕FIO[32] socket
⍝ TODO ⎕FIO[33] bind
⍝ TODO ⎕FIO[34] listen
⍝ TODO ⎕FIO[35] accept
⍝ TODO ⎕FIO[36] connect
⍝ TODO ⎕FIO[37] recv
⍝ TODO ⎕FIO[38] send
⍝ TODO ⎕FIO[40] select
⍝ TODO ⎕FIO[41] read
⍝ TODO ⎕FIO[42] write
⍝ TODO ⎕FIO[44] getsockname
⍝ TODO ⎕FIO[45] getpeername
⍝ TODO ⎕FIO[46] getsockopt
⍝ TODO ⎕FIO[47] setsockopt
⍝ TODO ⎕FIO[48] fscanf
⍝ TODO ⎕FIO[49] read entire file as nested lines

⍝ From '' ⎕FIO[0] '': Zi ←    ⎕FIO[50] Bu    gettimeofday()
⍝ Returns the current time since the Epoch in seconds, or a scalar 0 on error.
∇SECONDS←FIO∆GET_TIME_OF_DAY_S
  SECONDS←⎕FIO[50] 1
∇
⍝ Returns the current time since the Epoch in milliseconds, or a scalar 0 on
⍝ error.
∇MILISECONDS←FIO∆GET_TIME_OF_DAY_MS
  MILISECONDS←⎕FIO[50] 1000
∇
⍝ Returns the current time since the Epoch in microseconds, or a scalar 0 on
⍝ error.
∇MICROSECONDS←FIO∆GET_TIME_OF_DAY_US
  MICROSECONDS←⎕FIO[50] 1000000
∇

⍝ TODO ⎕FIO[51] mktime
⍝ TODO ⎕FIO[52] localtime
⍝ TODO ⎕FIO[53] gmtime
⍝ TODO ⎕FIO[54] chdir
⍝ TODO ⎕FIO[55] sscanf
⍝ TODO ⎕FIO[56] write nested lines to file
⍝ TODO ⎕FIO[57] fork and execve
⍝ TODO ⎕FIO[58] snprintf
⍝ TODO ⎕FIO[59] fcntl
⍝ TODO ⎕FIO[60] random byte vector
⍝ TODO ⎕FIO[61] seconds since Epoch; Bv←YYYY [MM DD [HH MM SS]]   ???????

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Utility Functions                                                            ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Converts a byte vector to a UTF-8 encoded character vector.
∇UTF8←FIO∆BYTES_TO_UTF8 BYTES
  UTF8←19 ⎕CR ⎕UCS BYTES
∇
⍝ Converts a UTF-8 encoded character vector to a byte vector.
∇BYTES←FIO∆UTF8_TO_BYTES UTF8
  BYTES←⎕UCS 18 ⎕CR UTF8
∇

⍝ Prints a message, with a newline, to stderr describing the value in ERRNO. If
⍝ MESSAGE is not an empty list, it will be prepended to the printed message with
⍝ a colon and space.
∇FIO∆PERROR MESSAGE; NEWLINE
  NEWLINE←FIO∆UTF8_TO_BYTES "\n"

  →(0≡≢MESSAGE) ⍴ LNO_MESSAGE
    ⊣ FIO∆STDERR FIO∆FWRITE⍨ NEWLINE,⍨(FIO∆STRERROR FIO∆ERRNO),⍨FIO∆UTF8_TO_BYTES MESSAGE,": "
    →LMESSAGE
  LNO_MESSAGE:
    ⊣ FIO∆STDERR FIO∆FWRITE⍨ NEWLINE,⍨FIO∆STRERROR FIO∆ERRNO
  LMESSAGE:
∇

⍝ Splits a vector by a delimiter value into a nested vector of vectors. If a
⍝ vector ends up being empty, it will still be included in the result (i.e.
⍝ VALUE VALUE DELIMETER DELIMETER VALUE -> (VALUE VALUE) () (VALUE).) The
⍝ delimiter value will not appear in the resulting vectors.
∇RESULT←DELIMETER FIO∆SPLIT VECTOR
  RESULT←DELIMETER~⍨¨VECTOR⊂⍨1++\VECTOR∊DELIMETER
∇
⍝ Splits a vector by a delimiter value into a nested vector of vectors. If a
⍝ vector ends up being empty, it will not be included in the result (i.e. VALUE
⍝ VALUE DELIMETER DELIMETER VALUE -> (VALUE VALUE) (VALUE).) The delimiter value
⍝ will not appear in the resulting vectors.
∇RESULT←DELIMETER FIO∆SPLIT_CLEAN VECTOR
  RESULT←VECTOR⊂⍨~VECTOR∊DELIMETER
∇

⍝ Splits a file path into it's seperate parts and removes the seperators (i.e.
⍝ FIO∆SPLIT_PATH "../a/p///apples" → ".." "a" "p" "apples".)
∇PATHS←FIO∆SPLIT_PATH PATH
  PATHS←'/' FIO∆SPLIT_CLEAN PATH
∇
⍝ Joins two paths together with a seperator.
∇PATH←FRONT_PATH FIO∆JOIN_PATH BACK_PATH
  PATH←FRONT_PATH,'/',BACK_PATH
∇

⍝ Reads input from the file descriptor until EOF is reached and outputs the
⍝ contents as a byte vector.
⍝ ←The byte vector, or a scalar 0, if and error occurred or EOF was reached.
∇BYTE_VECTOR←FIO∆READ_ENTIRE_FD FD
  BYTE_VECTOR←⍬

  LREAD_LOOP:
    BYTE_VECTOR←BYTE_VECTOR,5000 FIO∆FREAD FD
    →(0≢FIO∆FEOF   FD) ⍴ LEND_READ_LOOP
    →(0≢FIO∆FERROR FD) ⍴ LEND_READ_LOOP
    →LREAD_LOOP
  LEND_READ_LOOP:

  →(BYTE_VECTOR≢⍬,0) ⍴ LSUCCESS
    BYTE_VECTOR←0
  LSUCCESS:
∇

⍝ Checks is the file path exists and is a directory.
∇RESULT←FIO∆IS_DIRECTORY PATH
  RESULT←"0" ⎕EA "0≢FIO∆LIST_DIRECTORY PATH"
∇

⍝ TODO unit test.
⍝ Creates a directory at the given path and it's parent directories if they
⍝ don't exist.
⍝ →MODE - octal mode for the directory as an integer vector (i.e. 0 7 5 5.)
⍝ ←ERROR_CODES - a non-zero scalar number if an error occured.
∇ERROR←MODE FIO∆MKDIRS PATH; DIRECTORIES
  DIRECTORIES←FIO∆JOIN_PATH\ FIO∆SPLIT_PATH PATH
  ERROR←↑DIRECTORIES FIO∆MKDIR⍨¨ (≢DIRECTORIES)/⊂MODE
∇

⍝ TODO refactor.
⍝ TODO unit test.
⍝ TODO fix: failure on deleteing files.
∇ERROR←FIO∆RMDIRS PATH; CONTENTS;OTHER_PATH
  CONTENTS←FIO∆LIST_DIRECTORY PATH
  →(0≡CONTENTS) ⍴ LERROR

  →(0≡≢CONTENTS) ⍴ LDELETE_LOOP_END
  LDELETE_LOOP:
    OTHER_PATH←PATH FIO∆JOIN_PATH ↑CONTENTS
    CONTENTS←1↓CONTENTS
    →(FIO∆IS_DIRECTORY OTHER_PATH) ⍴ LIS_DIRECTORY
      →(0≢FIO∆UNLINK OTHER_PATH) ⍴ LERROR ◊ →LIS_FILE
    LIS_DIRECTORY:
      →(0≢FIO∆RMDIRS OTHER_PATH) ⍴ LERROR
    LIS_FILE:
    →(0≢≢CONTENTS) ⍴ LDELETE_LOOP
  LDELETE_LOOP_END:

  ERROR←FIO∆RMDIR PATH ◊ →LEND
LSUCCESS:
  ERROR←0  ◊ →LEND
LERROR:
  ERROR←¯1
LEND:
∇

⍝ Escapes the given shell argument with quotes.
∇ESCAPED_ARUGMENT←FIO∆ESCAPE_SHELL_ARGUMENT ARGUMENT
  ESCAPED_ARUGMENT←"'",⍨"'",∊(ARGUMENT,⍨⊂"'\\''")[1+(⍳⍨ARGUMENT)×~ARGUMENT∊"'"]
∇
⍝ Joins two shell arguments together with a space.
∇RESULT←FRONT_ARGUMENT FIO∆JOIN_SHELL_ARGUMENTS BACK_ARGUMENT
  RESULT←FRONT_ARGUMENT,' ',BACK_ARGUMENT
∇
