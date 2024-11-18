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
⍝   - Code cleanup.
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
⍝ From ⎕FIO '': ⎕FIO     0     return a list of open file descriptors
∇FDS←FIO∆LIST_FDS
  FDS←⎕FIO 0
∇

⍝ Returns the value of ERRNO for the previous ⎕FIO-C function.
⍝ From ⎕FIO '': Zi ←    ⎕FIO[ 1] ''    errno (of last call)
∇ERRNO←FIO∆ERRNO
  ERRNO←⎕FIO[1] ''
∇

⍝ Returns a byte vector describing the provided ERRNO.
⍝ From ⎕FIO '': Zs ←    ⎕FIO[ 2] Be    strerror(Be)
∇BYTES←FIO∆STRERROR ERRNO
  ⍝ ⎕FIO[2] actually returns a character vector of the bytes, so ⎕UCS is used to
  ⍝ convert them to numbers.
  BYTES←⎕UCS (⎕FIO[2] ERRNO)
∇

⍝ Opens a file with fopen.
⍝ MODE - open mode (i.e. "w", "r+", etc..)
⍝ FD - the file descriptor, or a scalar number less than 1 on failure.
⍝ From ⎕FIO '': Zh ← As ⎕FIO[ 3] Bs    fopen(Bs, As) filename Bs mode As
∇FD←MODE FIO∆FOPEN PATH
  FD←MODE ⎕FIO[3] PATH
∇

⍝ Closes a file descriptor.
⍝ ERROR - 0, if successful.
⍝ From ⎕FIO '': Ze ←    ⎕FIO[ 4] Bh    fclose(Bh)
∇ERROR←FIO∆FCLOSE FD
  ERROR←⎕FIO[4] FD
∇

⍝ Reads bytes up to specified number of bytes from the file descriptor.
⍝ BYTES - The data read, as a byte vector, or a scalar 0, if there was an error
⍝         or EOF was reached.
⍝ From ⎕FIO '': Zb ← Ai ⎕FIO[ 6] Bh    fread(Zi, 1, Ai, Bh) 1 byte per Zb
∇BYTES←MAXIMUM_BYTES FIO∆FREAD FD
  BYTES←MAXIMUM_BYTES ⎕FIO[6] FD
∇

⍝ Writes a byte vector to the file descriptor.
⍝ BYTES_WRITTEN -The number of bytes written.
⍝ From ⎕FIO '': Zi ← Ab ⎕FIO[ 7] Bh    fwrite(Ab, 1, ⍴Ai, Bh) 1 byte per Ai
∇BYTES_WRITTEN←BYTES FIO∆FWRITE FD
  BYTES_WRITTEN←BYTES ⎕FIO[7] FD
∇

⍝ Reads bytes to a newline or up to a specified number of bytes from the file
⍝ descriptor. Newlines are included in the output.
⍝ BYTES - The data read, as a byte vector, or a scalar 0, if there was an error
⍝         or EOF was reached.
⍝ From ⎕FIO '': Zb ← Ai ⎕FIO[ 8] Bh    fgets(Zb, Ai, Bh) 1 byte per Zb
∇BYTES←MAXIMUM_BYTES FIO∆FGETS FD
  BYTES←MAXIMUM_BYTES ⎕FIO[8] FD

  →(⍬≢BYTES) ⍴ LSUCCESS
    BYTES←0
  LSUCCESS:
∇

⍝ Reads one byte from the file descriptor, or a scalar 0, if there was an error
⍝ or EOF.
⍝ From ⎕FIO '': Zb ←    ⎕FIO[ 9] Bh    fgetc(Zb, Bh) 1 byte
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
⍝ From ⎕FIO '': Zi ←    ⎕FIO[19] Bh    unlink(Bc)
∇ERROR←FIO∆UNLINK PATH
  ERROR←⎕FIO[19] PATH
∇

⍝ Creates a directory at the given path if it doesn't exist. Does not recurse.
⍝ MODE - octal mode for the directory as an integer vector (i.e. 0 7 5 5.)
⍝ ERROR - a non-zero scalar number if an error occured.
⍝ From ⎕FIO '': Zi ← Ai ⎕FIO[20] Bh    mkdir(Bc, AI)
∇ERROR←MODE FIO∆MKDIR PATH
  ERROR←PATH ⎕FIO[20]⍨ 8⊥MODE
∇

⍝ Deletes the directory at the given path.
⍝ ERROR - a non-zero scalar number if an error occured.
⍝ From ⎕FIO '': Zi ←    ⎕FIO[21] Bh    rmdir(Bc)
∇ERROR←FIO∆RMDIR PATH
  ERROR←⎕FIO[21] PATH
∇

⍝ Prints formatted output to a file descriptor, like C fprintf.
⍝ FORMAT_ARGUMENTS - a vector containing the format as the first element, and
⍝                    the arguments being the remaining elements.
⍝ BYTES_WRITTEN - the number of bytes written, or a scalar negative number, if
⍝                 an error ocurred.
∇BYTES_WRITTEN←FORMAT_ARGUMENTS FIO∆FPRINTF FD
  BYTES_WRITTEN←FORMAT_ARGUMENTS ⎕FIO[22] FD
∇

⍝ TODO Unit test
⍝ Zh ← As ⎕FIO[24] Bs    popen(Bs, As) command Bs mode As
⍝ Stars the given command in a subprocess.
⍝ →⍵ - command.
⍝ ←The process' read-only file descriptor, or a scalar 0 on failure.
⍝FIO∆POPEN_READ←{⎕FIO[24] ⍵}
⍝ TODO Unit test
⍝ Stars the given command in a subprocess.
⍝ →⍵ - command.
⍝ ←The process' write-only file descriptor, or a scalar 0 on failure.
⍝FIO∆POPEN_WRITE←{"w" ⎕FIO[24] ⍵}

⍝ TODO Unit test
⍝ Ze ←    ⎕FIO[25] Bh    pclose(Bh)
⍝ Closes a file descripter opened with FIO∆POPEN_READ.
⍝ →⍵ - process file descriptor.
⍝ ←Process exit code, or a scalar ¯1 on failure.
⍝FIO∆PCLOSE←{⎕FIO[25] ⍵}

⍝ Reads in the entirety of the file at the given path as a byte vector.
⍝ BYTE_VECTOR← - The byte vector, or a scalar 0 on failure.
⍝ From FIO⎕ '': Zb ←    ⎕FIO[26] Bs    return entire file Bs as byte vector
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

⍝ TODO Unit test
⍝ Zn ←    ⎕FIO[29] Bs    return file names in directory Bs
⍝ →⍵ - directory file path.
⍝ ←The filenames in the directory, or a scalar ¯2 on failure.
⍝FIO∆LIST_DIRECTORY←{⎕FIO[29] ⍵}

⍝ TODO Unit test
⍝ Zi ←    ⎕FIO[50] Bu    gettimeofday()
⍝ Returns the current time since the Epoch in either seconds, milliseconds, or
⍝ microseconds.
⍝ →⍵ - the time divisor. 1 - seconds, 1000 - milliseconds, 1000000 -
⍝ microseconds.
⍝FIO∆GET_TIME_OF_DAY←{⎕FIO[50] ⍵}

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

⍝ TODO Unit test
⍝ Checks is the file path exists and is a directory.
⍝ →⍵ - directory file path.
⍝ ←1 if the file path represents a directory, else 0.
⍝FIO∆IS_DIRECTORY←{¯2≢FIO∆LIST_DIRECTORY ⍵}

⍝ TODO Unit test
⍝ Splits a file path into it's seperate parts and removes the seperators (i.e.
⍝ FIO∆SPLIT_PATH "../a/p///apples" → ".." "a" "p" "apples"
⍝FIO∆SPLIT_PATH←{'/' FIO∆SPLIT_CLEAN ⍵}
⍝ TODO Unit test
⍝ Joins two file paths together with a seperator.
⍝FIO∆JOIN_PATHS←{⍺,'/',⍵}

⍝ TODO Unit test
⍝ Creates the given directory and it's parent directories if they don't exist.
⍝ →PATH - file path.
⍝ →MODE - octal mode for the directory as an integer vector (i.e. 0 7 5 5.)
⍝ ←ERROR_CODES - The list of error codes from FIO∆MKDIR_MODE for each directory
⍝ level, non-zero if an error occured.
⍝∇ERROR_CODES←MODE FIO∆MKDIRS_MODE PATH; DIRECTORIES
⍝  DIRECTORIES←FIO∆JOIN_PATHS\ FIO∆SPLIT_PATH PATH
⍝  ERROR_CODES←{MODE FIO∆MKDIR_MODE ⍵}¨ DIRECTORIES
⍝∇
⍝ TODO Unit test
⍝ Creates the given directory and it's parent directories if they don't exist
⍝ with file mode 0755.
⍝ →⍵ - file path.
⍝ ←Non zero if an error occured.
⍝ ←The list of error codes from FIO∆MKDIRS_MODE for each directory level,
⍝ non-zero if an error occured.
⍝FIO∆MKDIRS←{(0 7 5 5) FIO∆MKDIRS_MODE ⍵}

⍝ TODO Unit test
⍝ Replaces all instances of a character sequence in a character vector with
⍝ another one.
⍝ →MATCH_REPLACEMENT - A two-element nested array of character vectors, the
⍝ first being the vector to match, and the second being the replacement.
⍝∇RESULT←MATCH_REPLACEMENT FIO∆CVECTOR_REPLACE CHARACTER_VECTOR; MATCH;REPLACEMENT
⍝  MATCH←↑MATCH_REPLACEMENT[1]
⍝  REPLACEMENT←↑MATCH_REPLACEMENT[2]
⍝
⍝  RESULT←∊CHARACTER_VECTOR{(⍺ REPLACEMENT)[1+⍵]}¨CHARACTER_VECTOR∊MATCH
⍝∇

⍝ TODO Unit test
⍝ Escapes the given shell argument with quotes. Intended for use with
⍝ FIO∆POPEN_{READ,WRITE}
⍝FIO∆ESCAPE_SHELL_ARGUMENT←{"'","'",⍨ ⍵ FIO∆CVECTOR_REPLACE⍨ "'" "'\\''"}
