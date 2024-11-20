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
⍝ DATA TYPES:
⍝  string - a character vector.
⍝  bytes - a number vector whose elements, N, are 0≤N≤255.
⍝  fd - a scalar number representing a file descriptor.
⍝  errno - a scalar number representing an error a la C's ERRNO.
⍝  boolean - a scalar 0, for false, or a 1, for true.
⍝  any - any value of any type.
⍝  void - used in optionals to indicate no value is returned.
⍝  uint - scalar whole number.
⍝  optional<TYPE>:
⍝    Error handling type. An optional is a nested vector, where
⍝    the first value is guaranteed to exist and is a boolean representing
⍝    whether the function succeeded.
⍝    If 1, the function succeded. If the function returned a result, it will be
⍝    the second value and of type TYPE.
⍝    If 0, the function failed. The second value is a string describing the
⍝    issue.
⍝
⍝ CHANGELOG:
⍝   Upcoming:
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
⍝ Utilities                                                                    ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Converts bytes to a UTF-8 encoded string.
⍝ BYTES: bytes.
⍝ UTF8: string.
∇UTF8←FIO∆BYTES_TO_UTF8 BYTES
  UTF8←19 ⎕CR ⎕UCS BYTES
∇

⍝ Converts a UTF-8 encoded string to bytes.
⍝ UTF8: string.
⍝ BYTES: bytes.
∇BYTES←FIO∆UTF8_TO_BYTES UTF8
  BYTES←⎕UCS 18 ⎕CR UTF8
∇

⍝ Splits VECTOR by DELIMITER into a nested vector of vectors. If any of the
⍝ resulting vectors are empty, they will still be included in RESULT (i.e.
⍝ value value delimeter delimeter value -> (value value) () (value).)  DELIMITER
⍝  will not appear in RESULT.
⍝ VECTOR: vector<any>.
⍝ DELIMETER: vector<any>.
⍝ RESULT: vector<vector<any>>.
∇RESULT←DELIMITER FIO∆SPLIT VECTOR
  RESULT←DELIMITER~⍨¨VECTOR⊂⍨1++\VECTOR∊DELIMITER
∇

⍝ Splits VECTOR by DELIMITER into a nested vector of vectors. If a any of
⍝ the resulting vectors are empty, they will not be included in RESULT (i.e.
⍝ value value delimeter delimeter value -> (value value) (value).) DELIMITER
⍝ will not appear in RESULT.
⍝ VECTOR: vector<any>.
⍝ DELIMITER: vector<any>.
⍝ RESULT: vector<vector<any>>.
∇RESULT←DELIMITER FIO∆SPLIT_CLEAN VECTOR
  RESULT←VECTOR⊂⍨~VECTOR∊DELIMITER
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ ERRNO                                                                        ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Returns the value of ERRNO for the previous ⎕FIO C function.
⍝ ERRNO: errno.
∇ERRNO←FIO∆ERRNO
  ⍝ Zi ←    ⎕FIO[ 1] ''    errno (of last call)
  ERRNO←⎕FIO[1] ''
∇

⍝ Returns a description of the provided ERRNO.
⍝ ERRNO: errno.
⍝ DESCRIPTION: string.
∇DESCRIPTION←FIO∆STRERROR ERRNO
  ⍝ Zs ←    ⎕FIO[ 2] Be    strerror(Be)
  ⍝ ⎕FIO[2] actually returns a character vector of bytes, so ⎕UCS is used to
  ⍝ convert them to bytes.
  DESCRIPTION←FIO∆BYTES_TO_UTF8 ⎕UCS (⎕FIO[2] ERRNO)
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ File and Directory Handling                                                  ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Splits a file path into it's seperate parts and removes the seperators (i.e.
⍝ FIO∆SPLIT_PATH "../a/p///apples" → ".." "a" "p" "apples".)
⍝ PATH: string.
⍝ PATHS: vector<string>.
∇PATHS←FIO∆SPLIT_PATH PATH
  PATHS←'/' FIO∆SPLIT_CLEAN PATH
∇
⍝ FRONT_PATH: string.
⍝ BACK_PATH: string.
⍝ PATH: string.
⍝ Joins two paths together with a seperator.
∇PATH←FRONT_PATH FIO∆JOIN_PATH BACK_PATH
  PATH←FRONT_PATH,'/',BACK_PATH
∇

⍝ Returns a vector of strings with the contents of the directory at the given
⍝ path.
⍝ PATH: string.
⍝ CONTENTS: optional<vector<string>>.
∇CONTENTS←FIO∆LIST_DIRECTORY PATH
  ⍝ Zn ←    ⎕FIO[29] Bs    return file names in directory Bs
  CONTENTS←⎕FIO[29] PATH

  →(1≤≡CONTENTS) ⍴ LSUCCESS
    ⍝ Failed to list PATH.
    CONTENTS←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LSUCCESS:
    CONTENTS←1 CONTENTS
  LSWITCH_END:
∇

⍝ Returns path of the current working directory.
⍝ DIRECTORY: optional<string>.
∇PATH←FIO∆CURRENT_DIRECTORY
  ⍝ Zs ←    ⎕FIO 30        getcwd()
  PATH←⎕FIO 30

  →(1≤≡PATH) ⍴ LSUCCESS
    ⍝ Failed to list directory.
    PATH←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LSUCCESS:
    PATH←1 PATH
  LSWITCH_END:
∇

⍝ TODO make fail if path exists and is not directory.
⍝ Creates a directory at the given path if it doesn't exist. Does not recurse.
⍝ MODE: vector<uint> - octal mode for the directory (i.e. 7 5 5.)
⍝ SUCCESS: optional<void>.
∇SUCCESS←MODE FIO∆MAKE_DIRECTORY PATH
  ⍝ Zi ← Ai ⎕FIO[20] Bh    mkdir(Bc, AI)
  SUCCESS←PATH ⎕FIO[20]⍨ 8⊥MODE

  →(0≡SUCCESS) ⍴ LSUCCESS
    SUCCESS←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LSUCCESS:
    SUCCESS←⍬,1
  LSWITCH_END:
∇

⍝ Common file descriptors.
FIO∆STDIN←0
FIO∆STDOUT←1
FIO∆STDERR←2

⍝ Returns open file descriptors.
⍝ FDS: vector<fd>.
∇FDS←FIO∆LIST_FDS
  ⍝ ⎕FIO     0     return a list of open file descriptors
  FDS←⎕FIO 0
∇

⍝ Opens a file.
⍝ MODE: string - open mode (i.e. "w", "r+", etc..). See 'man fopen' for details.
⍝ FD: optional<fd> - the descriptor of the opened file.
∇FD←MODE FIO∆OPEN_FILE PATH
  ⍝ Zh ← As ⎕FIO[ 3] Bs    fopen(Bs, As) filename Bs mode As
  FD←MODE ⎕FIO[3] PATH

  →(1≤FD) ⍴ LSUCCESS
    FD←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LFAIL
  LSUCCESS:
    FD←1 FD
  LFAIL:
∇

⍝ Closes a file descriptor.
⍝ FD: fd.
⍝ SUCCESS: optional<void>.
∇SUCCESS←FIO∆CLOSE_FD FD
  ⍝ Ze ←    ⎕FIO[ 4] Bh    fclose(Bh)
  ⍝ ⎕FIO[4] throws an APL exception on an unopen fd.
  SUCCESS←"→LEXCEPTION" ⎕EA "⎕FIO[4] FD"
  →(0≡SUCCESS) ⍴ LSUCCESS
    ⍝ Failed to close FD.
    SUCCESS←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LEXCEPTION:
    SUCCESS←0 "Either APL exception or not an open file descriptor" ◊ →LSWITCH_END
  LSUCCESS:
    SUCCESS←⍬,1
  LSWITCH_END:
∇

⍝ Returns whether EOF was reached for the file descriptor. If the file
⍝ descriptor is not open, returns true.
⍝ FD: fd.
⍝ EOF_REACHED: boolean.
∇EOF_REACHED←FIO∆EOF_FD FD
  ⍝ Zi ←    ⎕FIO[10] Bh    feof(Bh).
  ⍝ ⎕FIO[10] throws an APL exception on an unopen fd.
  EOF_REACHED←0≢"→LEXCEPTION" ⎕EA "⎕FIO[10] FD"
  →LSUCCESS
  LEXCEPTION:
    EOF_REACHED←1
  LSUCCESS:
∇

⍝ Returns whether an error ocurred with the file descriptor. If the file
⍝ descriptor is not open, returns true.
⍝ FD: fd.
⍝ HAS_ERROR: boolean.
∇HAS_ERROR←FIO∆ERROR_FD FD
  ⍝ Ze ←    ⎕FIO[11] Bh    ferror(Bh)
  HAS_ERROR←0≢"→LEXCEPTION" ⎕EA "⎕FIO[11] FD"
  →LSUCCESS
  LEXCEPTION:
    HAS_ERROR←1
  LSUCCESS:
∇

⍝ Reads bytes up to specified number of bytes from the file descriptor.
⍝ MAXIMUM_BYTES: uint - the maximum number of bytes to read.
⍝ FD: fd.
⍝ BYTES: optional<bytes>.
∇BYTES←MAXIMUM_BYTES FIO∆READ_FD FD
  ⍝ Zb ← Ai ⎕FIO[ 6] Bh    fread(Zi, 1, Ai, Bh) 1 byte per Zb
  ⍝ ⎕FIO[6] throws an APL exception on an unopen fd.
  BYTES←"→LEXCEPTION" ⎕EA "MAXIMUM_BYTES ⎕FIO[6] FD"
  →(0≢BYTES) ⍴ LSUCCESS
    ⍝ Failed to read FD.
    BYTES←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LEXCEPTION:
    BYTES←0 "Either APL exception or not an open file descriptor" ◊ →LSWITCH_END
  LSUCCESS:
    BYTES←1 BYTES
  LSWITCH_END:
∇

⍝ Reads bytes up to a newline or a specified number of bytes from the file
⍝ descriptor. Newlines are included in the output.
⍝ MAXIMUM_BYTES: uint - the maximum number of bytes to read.
⍝ FD: fd.
⍝ BYTES: optional<bytes>.
∇BYTES←MAXIMUM_BYTES FIO∆READ_LINE_FD FD
  ⍝ Zb ← Ai ⎕FIO[ 8] Bh    fgets(Zb, Ai, Bh) 1 byte per Zb
  ⍝ ⎕FIO[8] throws an APL exception on an unopen fd.
  BYTES←"→LEXCEPTION" ⎕EA "MAXIMUM_BYTES ⎕FIO[8] FD"
  →(⍬≢BYTES) ⍴ LSUCCESS
    ⍝ Failed to read FD.
    BYTES←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LEXCEPTION:
    BYTES←0 "Either APL exception or not an open file descriptor" ◊ →LSWITCH_END
  LSUCCESS:
    BYTES←1 BYTES
  LSWITCH_END:
∇

⍝ Reads bytes from a file descriptor until EOF is reached.
⍝ FD: fd.
⍝ BYTES: optional<bytes>.
∇BYTES←FIO∆READ_ENTIRE_FD FD; BUFFER
  →(~FIO∆EOF_FD FD) ⍴ LNOT_EOF
    BYTES←0 "Reached EOF" ◊ →LEND
  LNOT_EOF:

  BYTES←⍬
  LREAD_LOOP:
    BUFFER←5000 FIO∆READ_FD FD
    →(~↑BUFFER) ⍴ LEND_READ_LOOP
    BYTES←↑BUFFER[2] ◊ →LREAD_LOOP
  LEND_READ_LOOP:

  →(~FIO∆ERROR_FD FD) ⍴ LSUCCESS
    BYTES←0 BUFFER[2] ◊ →LFAIL
  LSUCCESS:
    BYTES←1 BYTES
  LFAIL:

LEND:
∇

⍝ Reads in an entire file as bytes.
⍝ PATH: string - path to the file.
⍝ Bytes: optional<bytes>.
∇BYTES←FIO∆READ_ENTIRE_FILE PATH
  ⍝ Zb ←    ⎕FIO[26] Bs    return entire file Bs as byte vector
  ⍝ ⎕FIO[26] throws an APL exception on directories, and probably some other
  ⍝ things.
  BYTES←"→LEXCEPTION" ⎕EA "⎕FIO[26] PATH"
  →(1≤≡BYTES) ⍴ LSUCCESS
    ⍝ Failed to read file.
    BYTES←0 "File does not exist" ◊ →LSWITCH_END
  LEXCEPTION:
    BYTES←0 "Either APL exception or not a file" ◊ →LSWITCH_END
  LSUCCESS:
    ⍝ ⎕FIO[26] actually returns a string of bytes, so ⎕UCS is used to convert
    ⍝ them to numbers.
    BYTES←1 (⎕UCS BYTES)
  LSWITCH_END:
∇

⍝ Writes bytes to the file descriptor.
⍝ BYTES: bytes.
⍝ FD: fd.
⍝ SUCCESS: optional<void>.
∇SUCCESS←BYTES FIO∆WRITE_FD FD
  ⍝ Zi ← Ab ⎕FIO[ 7] Bh    fwrite(Ab, 1, ⍴Ai, Bh) 1 byte per Ai
  ⍝ ⎕FIO[7] throws an APL exception on an unopen fd.
  SUCCESS←"→LEXCEPTION" ⎕EA "BYTES ⎕FIO[7] FD"
  →((≢BYTES)≡SUCCESS) ⍴ LSUCCESS
    ⍝ Failed to write to FD.
    SUCCESS←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LEXCEPTION:
    SUCCESS←0 "Either APL exception or not an open file descriptor" ◊ →LSWITCH_END
  LSUCCESS:
    SUCCESS←⍬,1
  LSWITCH_END:
∇

⍝ TODO add printf.
⍝ Prints formatted output to a file descriptor, like C fprintf.
⍝ FORMAT_ARGUMENTS: vector<[1]string, any> - a vector with the format as the
⍝                   first element, and the arguments as the rest.
⍝ FD: fd.
⍝ BYTES_WRITTEN: optional<uint> - the number of bytes written.
∇BYTES_WRITTEN←FORMAT_ARGUMENTS FIO∆FPRINTF FD
  ⍝ Zi ← A  ⎕FIO[22] Bh    fprintf(Bh,     A1, A2...) format A1
  BYTES_WRITTEN←"→LEXCEPTION" ⎕EA "FORMAT_ARGUMENTS ⎕FIO[22] FD"
  →(0≤BYTES_WRITTEN) ⍴ LSUCCESS
    ⍝ Failed to write to FD.
    BYTES_WRITTEN←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LEXCEPTION:
    BYTES_WRITTEN←0 "Either APL exception or not an open file descriptor"
    →LSWITCH_END
  LSUCCESS:
    BYTES_WRITTEN←1 BYTES_WRITTEN
  LSWITCH_END:
∇

⍝ If PATH points to a file, it will be unlinked, possibly deleting it.
⍝ If PATH points to a directory, it will be deleted if empty.
⍝ PATH: string.
⍝ SUCCESS: optional<void>.
∇SUCCESS←FIO∆REMOVE PATH
  →(↑FIO∆LIST_DIRECTORY PATH) ⍴ LDIRECTORY
    ⍝ Zi ←    ⎕FIO[19] Bh    unlink(Bc)
    SUCCESS←⎕FIO[19] PATH ◊ →LFILE
  LDIRECTORY:
    ⍝ Zi ←    ⎕FIO[21] Bh    rmdir(Bc)
    SUCCESS←⎕FIO[21] PATH
  LFILE:

  →(0≡SUCCESS) ⍴ LSUCCESS
    ⍝ Failed to remove path.
    SUCCESS←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LSUCCESS:
    SUCCESS←⍬,1
  LSWITCH_END:
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Process Handling                                                             ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Escapes the given shell argument with quotes.
⍝ ARGUMENT: string.
⍝ ESCAPED_ARUGMENT: string.
∇ESCAPED_ARUGMENT←FIO∆ESCAPE_SHELL_ARGUMENT ARGUMENT
  ESCAPED_ARUGMENT←"'",⍨"'",∊(ARGUMENT,⍨⊂"'\\''")[1+(⍳⍨ARGUMENT)×~ARGUMENT∊"'"]
∇

⍝ TODO unit test.
⍝ Joins two shell arguments together with a space.
⍝ FRONT_ARGUMENT: string.
⍝ BACK_ARGUMENT: string.
⍝ RESULT: string.
∇RESULT←FRONT_ARGUMENT FIO∆JOIN_SHELL_ARGUMENTS BACK_ARGUMENT
  RESULT←FRONT_ARGUMENT,' ',BACK_ARGUMENT
∇

⍝ Runs the given command in the user's shell in a subprocess. Close with FD
⍝ FIO∆PCLOSE.
⍝ EXE_ARGUMENTS: vector<string> - a vector with the executable to run as the
⍝                first element, and the arguments to it as the rest.
⍝ FD: optional<fd> - the process' read-only file descriptor.
∇FD←FIO∆POPEN_READ EXE_ARGUMENTS
  ⍝ Zh ← As ⎕FIO[24] Bs    popen(Bs, As) command Bs mode As
  FD←"r" ⎕FIO[24] ↑FIO∆JOIN_SHELL_ARGUMENTS/ FIO∆ESCAPE_SHELL_ARGUMENT¨ EXE_ARGUMENTS

  →(1≤FD) ⍴ LSUCCESS
    ⍝ Failed to run popen.
    FD←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LSUCCESS:
    FD←1 FD
  LSWITCH_END:
∇

⍝ TODO add unit test
⍝ Runs the given command in the user's shell in a subprocess. Close with FD
⍝ FIO∆PCLOSE.
⍝ EXE_ARGUMENTS: vector<string> - a vector with the executable to run as the
⍝                first element, and the arguments to it as the rest.
⍝ FD: optional<fd> - The process' write-only file descriptor.
∇FD←FIO∆POPEN_WRITE EXE_ARGUMENTS
  ⍝ Zh ← As ⎕FIO[24] Bs    popen(Bs, As) command Bs mode As
  FD←"w" ⎕FIO[24] ↑FIO∆JOIN_SHELL_ARGUMENTS/ FIO∆ESCAPE_SHELL_ARGUMENT¨ EXE_ARGUMENTS

  →(1≤FD) ⍴ LSUCCESS
    ⍝ Failed to run popen.
    FD←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LSUCCESS:
    FD←1 FD
  LSWITCH_END:
∇

⍝ Closes a file descriptor opened with FIO∆POPEN_{READ,WRITE}.
⍝ FD: fd.
⍝ SUCCESS: optional<uint> - process exit code.
∇ERROR←FIO∆PCLOSE FD
  ⍝ Ze ←    ⎕FIO[25] Bh    pclose(Bh)
  ERROR←"→LEXCEPTION" ⎕EA "⎕FIO[25] FD"

  →(0≤ERROR) ⍴ LSUCCESS
    ⍝ Failed to run pclose.
    ERROR←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LEXCEPTION:
    ERROR←0 "Either APL exception or not an open file descriptor" ◊ →LSWITCH_END
  LSUCCESS:
    ERROR←1 ERROR
  LSWITCH_END:
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Time                                                                         ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Returns the current time since the Epoch in seconds.
⍝ S: optional<uint>.
∇S←FIO∆TIME_S
  ⍝ Zi ←    ⎕FIO[50] Bu    gettimeofday()
  S←⎕FIO[50] 1

  →(0≢S) ⍴ LSUCCESS
    ⍝ Failed to get time.
    S←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LSUCCESS:
    S←1 S
  LSWITCH_END:
∇

⍝ Returns the current time since the Epoch in milliseconds.
⍝ MILLISECONDS: optional<uint>.
∇MS←FIO∆TIME_MS
  ⍝ Zi ←    ⎕FIO[50] Bu    gettimeofday()
  MS←⎕FIO[50] 1000

  →(0≢MS) ⍴ LSUCCESS
    ⍝ Failed to get time.
    MS←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LSUCCESS:
    MS←1 MS
  LSWITCH_END:
∇

⍝ Returns the current time since the Epoch in microseconds.
⍝ MICROSECONDS: optional<uint>.
∇US←FIO∆TIME_US
  ⍝ Zi ←    ⎕FIO[50] Bu    gettimeofday()
  US←⎕FIO[50] 1000000

  →(0≢US) ⍴ LSUCCESS
    ⍝ Failed to get time.
    US←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →LSWITCH_END
  LSUCCESS:
    US←1 US
  LSWITCH_END:
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ TODO Consider adding the following ⎕FIO functions:
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
⍝ TODO FIO[12] - ftell
⍝ TODO FIO[13,14,15] - fseek
⍝ TODO FIO[16] - fflush.
⍝ TODO FIO[17] - fsync.
⍝ TODO FIO[18] - fstat.
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
⍝ TODO ⎕FIO[27] rename file.

⍝ TODO add defer system like what Zig has.
⍝ TODO add (or find) function to check if a file exists at a given path.

⍝ TODO add optional.
⍝ TODO unit test.
⍝ Creates a directory at the given path and it's parent directories if they
⍝ don't exist.
⍝ →MODE - octal mode for the directory as an integer vector (i.e. 0 7 5 5.)
⍝ ←ERROR_CODES - a non-zero scalar number if an error occured.
∇ERROR←MODE FIO∆MKDIRS PATH; DIRECTORIES
  DIRECTORIES←FIO∆JOIN_PATH\ FIO∆SPLIT_PATH PATH
  ERROR←↑DIRECTORIES FIO∆MKDIR⍨¨ (≢DIRECTORIES)/⊂MODE
∇

⍝ TODO add optional.
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
