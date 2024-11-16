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
FIO∆LIST_FDS←{⎕FIO 0}

⍝ Returns the value of ERRNO for the previous ⎕FIO-C function.
⍝ From ⎕FIO '': Zi ←    ⎕FIO[ 1] ''    errno (of last call)
FIO∆ERRNO←{⎕FIO[1] ''}

⍝ Returns a byte vector describing the provided ERRNO.
⍝ From ⎕FIO '': Zs ←    ⎕FIO[ 2] Be    strerror(Be)
⍝ ⎕FIO[2] actually returns a character vector of the bytes, so ⎕UCS is used
⍝ to convert them to numbers.
FIO∆STRERROR←{⎕UCS (⎕FIO[2] ⍵)}

⍝ Opens a file with fopen.
⍝ →⍺ - mode (i.e. "w", "r+", etc..)
⍝ →⍵ - file path.
⍝ ←The file descriptor, or a scalar number less than 1 on failure.
⍝ From ⎕FIO '': Zh ← As ⎕FIO[ 3] Bs    fopen(Bs, As) filename Bs mode As
FIO∆FOPEN←{⍺ ⎕FIO[3] ⍵}

⍝ Closes a file descriptor.
⍝ ←0, if successful.
⍝ From ⎕FIO '': Ze ←    ⎕FIO[ 4] Bh    fclose(Bh)
FIO∆FCLOSE←{⎕FIO[4] ⍵}

⍝ Reads bytes up to specified number of bytes from the file descriptor.
⍝ →⍵ - file descriptor.
⍝ →⍺ - maximum number of bytes to read in.
⍝ ←The data read, as a byte vector, or a scalar 0, if there was an error or EOF
⍝  was reached.
⍝ From ⎕FIO '': Zb ← Ai ⎕FIO[ 6] Bh    fread(Zi, 1, Ai, Bh) 1 byte per Zb
FIO∆FREAD←{⍺ ⎕FIO[6] ⍵}

⍝ TODO Unit test
⍝ Zi ← Ab ⎕FIO[ 7] Bh    fwrite(Ab, 1, ⍴Ai, Bh) 1 byte per Ai
⍝ Writes to a file descriptor.
⍝ →⍵ - file descriptor.
⍝ →⍺ - data as byte vector.
FIO∆FWRITE←{⍺ ⎕FIO[7] ⍵}

⍝ Reads bytes to a newline or up to a specified number of bytes from the file
⍝ descriptor. Newlines are included in the output.
⍝ →⍵ - file descriptor.
⍝ →⍺ - maximum number of bytes to read in.
⍝ ←The data read, as a byte vector, or a scalar 0, if there was an error or EOF
⍝  was reached.
⍝ From ⎕FIO '': Zb ← Ai ⎕FIO[ 8] Bh    fgets(Zb, Ai, Bh) 1 byte per Zb
FIO∆FGETS←{{↑(⍵ 0)[1+⍬≡⍵]}(⍺ ⎕FIO[8] ⍵)}

⍝ Reads on byte fro mthe file descriptor, or a scalar 0, if there was an error
⍝ or EOF.
⍝ From ⎕FIO '': Zb ←    ⎕FIO[ 9] Bh    fgetc(Zb, Bh) 1 byte
FIO∆FGETC←{⎕FIO[9] ⍵}

⍝ Retoruns a non-zero scalar number if EOF was reached for the file descriptor.
⍝ From ⎕FIO: '': Zi ←    ⎕FIO[10] Bh    feof(Bh)
FIO∆FEOF←{⎕FIO[10] ⍵}

⍝ Retoruns a non-zero scalar number if an error ocurred with the file
⍝ descriptor.
⍝ From ⎕FIO: '':  Ze ←    ⎕FIO[11] Bh    ferror(Bh)
FIO∆FERROR←{⎕FIO[11] ⍵}

⍝ TODO Unit test
⍝ Zi ← Ai ⎕FIO[20] Bh    mkdir(Bc, Ai)
⍝ Creates the given directory if it doesn't exist with file mode 0755. Does not
⍝ recurse.
⍝ →⍵ - file path.
⍝ ←Non zero if an error occured.
FIO∆MKDIR←{(8⊥0 7 5 5) ⎕FIO[20] ⍵}
⍝ TODO Unit test
⍝ Creates the given directory if it doesn't exist. Does not recurse.
⍝ →⍵ - file path.
⍝ →⍺ - octal mode for the directory as an integer vector (i.e. 0 7 5 5.)
⍝ ←Non zero if an error occured.
FIO∆MKDIR_MODE←{(8⊥⍺) ⎕FIO[20] ⍵}

⍝ TODO Unit test
⍝ Zi ← Ac ⎕FIO[23] Bh    fwrite(Ac, 1, ⍴Ac, Bh) 1 Unicode per Ac, Output UTF8
⍝ Writes a character vector to a file descriptor.
⍝ →⍵ - file descriptor.
⍝ →⍺ - characte vector.
⍝ ←Error code.
FIO∆FWRITE_CVECTOR←{⍺ ⎕FIO[23] ⍵}

⍝ TODO Unit test
⍝ Zh ← As ⎕FIO[24] Bs    popen(Bs, As) command Bs mode As
⍝ Stars the given command in a subprocess.
⍝ →⍵ - command.
⍝ ←The process' read-only file descriptor, or a scalar 0 on failure.
FIO∆POPEN_READ←{⎕FIO[24] ⍵}
⍝ TODO Unit test
⍝ Stars the given command in a subprocess.
⍝ →⍵ - command.
⍝ ←The process' write-only file descriptor, or a scalar 0 on failure.
FIO∆POPEN_WRITE←{"w" ⎕FIO[24] ⍵}

⍝ TODO Unit test
⍝ Ze ←    ⎕FIO[25] Bh    pclose(Bh)
⍝ Closes a file descripter opened with FIO∆POPEN_READ.
⍝ →⍵ - process file descriptor.
⍝ ←Process exit code, or a scalar ¯1 on failure.
FIO∆PCLOSE←{⎕FIO[25] ⍵}

⍝ TODO Unit test
⍝ Zb ←    ⎕FIO[26] Bs    return entire file Bs as byte vector
⍝ Reads in the enitrety of the file a byte vector.
⍝ →FILE_PATH - file path to read from.
⍝ BYTE_VECTOR← - The byte vector, or a scalar ¯2 on failure.
∇BYTE_VECTOR←FIO∆READ_ENTIRE_FILE PATH
  BYTE_VECTOR←⎕FIO[26] PATH

  →(¯2≡BYTE_VECTOR) ⍴ LERROR
    ⍝ ⎕FIO[26] actually returns a character vector of the bytes, so ⎕UCS is used
    ⍝ to convert them to numbers.
    BYTE_VECTOR←⎕UCS BYTE_VECTOR
  LERROR:
∇

⍝ TODO Unit test
⍝ Zn ←    ⎕FIO[29] Bs    return file names in directory Bs
⍝ →⍵ - directory file path.
⍝ ←The filenames in the directory, or a scalar ¯2 on failure.
FIO∆LIST_DIRECTORY←{⎕FIO[29] ⍵}

⍝ TODO Unit test
⍝ Zi ←    ⎕FIO[50] Bu    gettimeofday()
⍝ Returns the current time since the Epoch in either seconds, milliseconds, or
⍝ microseconds.
⍝ →⍵ - the time divisor. 1 - seconds, 1000 - milliseconds, 1000000 -
⍝ microseconds.
FIO∆GET_TIME_OF_DAY←{⎕FIO[50] ⍵}

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Utility Functions                                                            ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Converts a byte vector to a UTF-8 encoded character vector.
FIO∆BYTES_TO_UTF8←{19 ⎕CR ⎕UCS ⍵}
⍝ Converts a UTF-8 encoded character vector to a byte vector.
FIO∆UTF8_TO_BYTES←{⎕UCS 18 ⎕CR ⍵}

⍝ Prints a message, with a newline, to stderr describing the value in ERRNO. If
⍝ MESSAGE is not an empty list, it will be prepended to the printed message with
⍝ a colon and space.
∇PERROR MESSAGE; NEWLINE
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
  RESULT←{⍵~DELIMETER}¨VECTOR⊂⍨1++\VECTOR∊DELIMETER
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
FIO∆IS_DIRECTORY←{¯2≢FIO∆LIST_DIRECTORY ⍵}

⍝ TODO Unit test
⍝ Splits a file path into it's seperate parts and removes the seperators (i.e.
⍝ FIO∆SPLIT_PATH "../a/p///apples" → ".." "a" "p" "apples"
FIO∆SPLIT_PATH←{'/' FIO∆SPLIT_CLEAN ⍵}
⍝ TODO Unit test
⍝ Joins two file paths together with a seperator.
FIO∆JOIN_PATHS←{⍺,'/',⍵}

⍝ TODO Unit test
⍝ Creates the given directory and it's parent directories if they don't exist.
⍝ →PATH - file path.
⍝ →MODE - octal mode for the directory as an integer vector (i.e. 0 7 5 5.)
⍝ ←ERROR_CODES - The list of error codes from FIO∆MKDIR_MODE for each directory
⍝ level, non-zero if an error occured.
∇ERROR_CODES←MODE FIO∆MKDIRS_MODE PATH; DIRECTORIES
  DIRECTORIES←FIO∆JOIN_PATHS\ FIO∆SPLIT_PATH PATH
  ERROR_CODES←{MODE FIO∆MKDIR_MODE ⍵}¨ DIRECTORIES
∇
⍝ TODO Unit test
⍝ Creates the given directory and it's parent directories if they don't exist
⍝ with file mode 0755.
⍝ →⍵ - file path.
⍝ ←Non zero if an error occured.
⍝ ←The list of error codes from FIO∆MKDIRS_MODE for each directory level,
⍝ non-zero if an error occured.
FIO∆MKDIRS←{(0 7 5 5) FIO∆MKDIRS_MODE ⍵}

⍝ TODO Unit test
⍝ Replaces all instances of a character sequence in a character vector with
⍝ another one.
⍝ →MATCH_REPLACEMENT - A two-element nested array of character vectors, the
⍝ first being the vector to match, and the second being the replacement.
∇RESULT←MATCH_REPLACEMENT FIO∆CVECTOR_REPLACE CHARACTER_VECTOR; MATCH;REPLACEMENT
  MATCH←↑MATCH_REPLACEMENT[1]
  REPLACEMENT←↑MATCH_REPLACEMENT[2]

  RESULT←∊CHARACTER_VECTOR{(⍺ REPLACEMENT)[1+⍵]}¨CHARACTER_VECTOR∊MATCH
∇

⍝ TODO Unit test
⍝ Escapes the given shell argument with quotes. Intended for use with
⍝ FIO∆POPEN_{READ,WRITE}
FIO∆ESCAPE_SHELL_ARGUMENT←{"'","'",⍨ ⍵ FIO∆CVECTOR_REPLACE⍨ "'" "'\\''"}
