⍝!/usr/local/bin/apl --script

⍝ This file is part of fio.apl.
⍝
⍝ Copyright (c) 2024-2025 ona-li-toki-e-jan-Epiphany-tawa-mi
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

⍝ fio.apl GNU APL ⎕FIO abstraction library.

⍝ Synopsis:
⍝   TL;DR - ⎕FIO is too low-level IMO for use in APL and this library is my
⍝   highly-biased reimagining of it.
⍝
⍝   In GNU APL, interations with the operating system (file handling, spawning
⍝   processes, opening ports, etc.) are done with ⎕FIO. However, I find that
⍝   there are several problems with it.
⍝
⍝   Prior to version GNU APL 1.9, ⎕FIO functions were specified with an axis
⍝   argument, i.e. ⎕FIO[3] (fopen,) which lead to code that was hard to read.
⍝   Now you can specify them by name, i.e. ⎕FIO['fopen'] or ⎕FIO.fopen. This is
⍝   the reason I orignally developed this library, but there are still other
⍝   things for which I think this library has value.
⍝
⍝   The ⎕FIO functions are replicas of C functions, whose error handling methods
⍝   vary considerably between functions. This is fine in C, but APL is far more
⍝   abstract than C with a completely different way to represent logic. This
⍝   library provides, what I consider, to be a more consistent and sensible
⍝   error handling scheme through the use of a vector that replicates the
⍝   errorable types from other languages, like error unions in Zig or Either in
⍝   Haskell.
⍝
⍝   Many of the functions that handle file descriptors throw an exception on an
⍝   unopened file descriptor, instead of returning some kind of error code. I
⍝   think that this is kind of weird, and I have replaced it with the
⍝   aforementioned error handling.
⍝
⍝   Some of the functions are also annoying to use. For example, ⎕FIO[20],
⍝   mkdir, requires the file permissions to be converted from octal to decimal
⍝   numbers before calling. Functions such as these are given a more
⍝   user-friendly interface.
⍝
⍝   Additionally, this library provides a number of extra functions you will
⍝   probably like, such as recursively creating and deleting directories.
⍝
⍝   Note: functions have been added as-needed, so it will not cover everything
⍝   in ⎕FIO.

⍝ Usage:
⍝   Either include it into your project on one of the library search paths (run
⍝   ')LIBS' to see them,) and use ')COPY_ONCE fio.apl' to load it, or include it
⍝   directly via path, i.e. ')COPY_ONCE ./path/to/fio.apl'.
⍝
⍝   If the inclusion of ')COPY_ONCE' in scripts results in text output that you
⍝   don't want replace the command with '⊣ ⍎")COPY_ONCE <name or path>"'.

⍝ Data types:
⍝  string - a character vector.
⍝  byte - a number, n, where 0≤n≤255.
⍝  fd - a scalar number representing a file descriptor.
⍝  errno - a scalar number representing an error a la C's ERRNO.
⍝  boolean - a scalar 0, for false, or a 1, for true.
⍝  any - any value of any type.
⍝  uint - scalar whole number.
⍝  maybe<TYPE>:
⍝    Error handling type. A maybe is a nested vector, where the first value is
⍝    guaranteed to exist and is a boolean representing whether the function
⍝    succeeded.
⍝    If 1, the function succeded. If the function returned a result, it will be
⍝    the second value and of type TYPE. You can unwrap this value from a maybe
⍝    m by doing "↑1↓m"
⍝    If 0, the function failed. The second value is a string describing the
⍝    issue.
⍝  void - used in maybe to indicate no value is returned.

⍝ Changelog:
⍝   Upcoming:
⍝   - Fixed introduced bug in FIO∆PRINT and FIO∆PRINTF.
⍝   2.0.0:
⍝   - Removed defer system since it seems useless.
⍝   - Updated code style to use lowercase for variables. For you, the user, this
⍝     means FIO∆{STDIN,STDERR,STDOUT} are now FIO∆{stdin,stderr,stdout}.
⍝   - Improved typing information.
⍝   - Fixed FIO∆JOIN_PATH adding a seperator if one of the arguments was empty
⍝     (i.e.: "" FIO∆JOIN_PATH "test" -> "/test", which is obviously not good.)
⍝   - Renamed optional to maybe.
⍝   1.0.1:
⍝   - Fixed FIO∆READ_FD not reading from given file descriptor.
⍝   - Fixed FIO∆READ_ENTIRE_FD not properly returning read data.
⍝   - Swapped arugments for dyadic functions that work with file descriptors for
⍝     a better user experience.
⍝   - Added FIO∆PRINT_FD and FIO∆PRINT for easily outputting strings without
⍝     needing to convert them to bytes first.
⍝   - Renamed FIO∆FPRINTF -> FIO∆PRINTF_FD.
⍝   - Changed meta for unwrapping optionals from "↑O[2]" to "↑1↓V".
⍝   1.0.0:
⍝   - Relicensed as GPLv3+ (orignally zlib.)
⍝   - Code cleanup.
⍝   - Completely redid error handling in a more APL-friendly manner.
⍝   - Verified behavior with unit testing.
⍝   - Made FIO∆POPEN_READ and FIO∆POPEN_WRITE escape shell commands
⍝     automatically.
⍝   - Added FIO∆DEFER and FIO∆DEFER_END which replicate the defer statement in
⍝     languages like Zig.
⍝   - FIO∆MAKE_DIRECTORY (was FIO∆MKDIR) now fails if PATH is a file.
⍝   - Made functions that work with file descriptors no longer throw APL
⍝     exceptions on unopen file descriptors.
⍝   - Added FIO∆PERROR, FIO∆LIST_FDS, FIO∆STRERROR, FIO∆ERRNO, FIO∆READ_LINE_FD,
⍝     FIO∆REMOVE, FIO∆REMOVE_RECURSIVE, FIO∆FPRINTF, FIO∆PRINTF,
⍝     FIO∆CURRENT_DIRECTORY.
⍝     FIO∆IS_FILE.
⍝   - Renamed FIO∆FOPEN -> FIO∆OPEN_FILE, FIO∆FLOSE -> FIO∆CLOSE_FD, FIO∆FEOF ->
⍝     FIO∆EOF_FD, FIO∆FERROR -> FIO∆ERROR_FD, FIO∆FREAD -> FIO∆READ_FD,
⍝     FIO∆FWRITE -> FIO∆WRITE_FD, FIO∆MKDIR -> FIO∆MAKE_DIRECTORY, FIO∆MKDIRS ->
⍝     FIO∆MAKE_DIRECTORIES,
⍝   - Split FIO∆GET_TIME_OF_DAY into FIO∆TIME_S, FIO∆TIME_MS, and FIO∆TIME_US.
⍝   - Removed FIO∆IS_DIRECTORY; FIO∆LIST_DIRECTORY makes it redundant.
⍝   0.1.0:
⍝   - Intial release.

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Metadata                                                                     ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ See for details: https://www.gnu.org/software/apl/Library-Guidelines-GNU-APL.html
FIO⍙metadata←"Author" "BugEmail" "Documentation" "Download" "LICENSE" "Portability" "Provides" "Requires" "Version",⍪"ona li toki e jan Epiphany tawa mi" "" "https://paltepuk.xyz/cgit/fio.apl.git/about/" "https://paltepuk.xyz/cgit/fio.apl.git/plain/fio.apl" "GPLv3+" "L3" "FIO" "" "2.0.0"

⍝ Links:
⍝ - paltepuk - https://paltepuk.xyz/cgit/fio.apl.git/about/
⍝ - paltepuk (I2P) - http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p/cgit/fio.apl.git/about/
⍝ - paltepuk (Tor) - http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion/cgit/fio.apl.git/about/
⍝ - GitHub - https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/fio.apl/

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Utilities                                                                    ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Converts bytes to a UTF-8 encoded string.
⍝ →bytes: vector<byte>.
⍝ ←utf8: string.
∇utf8←FIO∆BYTES_TO_UTF8 bytes
  utf8←19 ⎕CR ⎕UCS bytes
∇

⍝ Converts a UTF-8 encoded string to bytes.
⍝ →utf8: string.
⍝ ←bytes: vector<byte>.
∇bytes←FIO∆UTF8_TO_BYTES utf8
  bytes←⎕UCS 18 ⎕CR utf8
∇

⍝ Splits vector by delimiter into a nested vector of vectors. If any of the
⍝ resulting vectors are empty, they will still be included in result (i.e.
⍝ value value delimeter delimeter value -> (value value) () (value).) delimiter
⍝ will not appear in result.
⍝ →vector: vector<any>.
⍝ →delimeter: any.
⍝ ←result: vector<vector<any>>.
∇result←delimiter FIO∆SPLIT vector
  result←delimiter~⍨¨vector⊂⍨1++\vector∊delimiter
∇

⍝ Splits vector by delimiter into a nested vector of vectors. If a any of
⍝ the resulting vectors are empty, they will not be included in result (i.e.
⍝ value value delimeter delimeter value -> (value value) (value).) delimiter
⍝ will not appear in result.
⍝ →vector: vector<any>.
⍝ →delimiter: any.
⍝ ←result: vector<vector<any>>.
∇result←delimiter FIO∆SPLIT_CLEAN vector
  result←vector⊂⍨~vector∊delimiter
∇

⍝ Prints a string out to stdout.
⍝ →string: string.
⍝ ←success: maybe<void>.
∇success←FIO∆PRINT string
  success←FIO∆stdout FIO∆PRINT_FD string
∇

⍝ Prints formatted output to stdout, like C printf.
⍝ →format_arguments: vector<string, any...> - a vector with the format as the
⍝ first element, and the arguments as the rest.
⍝ ←bytes_written: maybe<uint> - the number of bytes written.
∇bytes_written←FIO∆PRINTF format_arguments
  bytes_written←FIO∆stdout FIO∆PRINTF_FD format_arguments
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ ERRNO                                                                        ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Returns the value of errno for the previous ⎕FIO C function.
⍝ ←errno: errno.
∇errno←FIO∆ERRNO
  ⍝ Zi ←    ⎕FIO[ 1] ''    errno (of last call)
  errno←⎕FIO[1] ''
∇

⍝ Returns a description of the provided errno.
⍝ →errno: errno.
⍝ ←description: string.
∇description←FIO∆STRERROR errno
  ⍝ Zs ←    ⎕FIO[ 2] Be    strerror(Be)
  ⍝ ⎕FIO[2] actually returns a character vector of bytes, so ⎕UCS is used to
  ⍝ convert them to bytes.
  description←FIO∆BYTES_TO_UTF8 ⎕UCS (⎕FIO[2] errno)
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ File and Directory Handling                                                  ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Splits a file path into it's seperate parts and removes the seperators (i.e.
⍝ FIO∆SPLIT_PATH "../a/p///apples" → ".." "a" "p" "apples".)
⍝ →path: string.
⍝ ←paths: vector<string>.
∇paths←FIO∆SPLIT_PATH path
  paths←'/' FIO∆SPLIT_CLEAN path
∇
⍝ Joins two paths together with a seperator.
⍝ →front_path: string.
⍝ →back_path: string.
⍝ ←path: string.
∇path←front_path FIO∆JOIN_PATH back_path
  →(0≡≢front_path) ⍴ lempty_front
  →(0≡≢back_path) ⍴ lempty_back
    path←front_path,'/',back_path ◊ →lswitch_end
  lempty_front:
    path←back_path ◊ →lswitch_end
  lempty_back:
    path←front_path ◊ →lswitch_end
  lswitch_end:
∇

⍝ Returns a vector of strings with the contents of the directory at the given
⍝ path.
⍝ →path: string.
⍝ ←contents: maybe<vector<string>>.
∇contents←FIO∆LIST_DIRECTORY path
  ⍝ Zn ←    ⎕FIO[29] Bs    return file names in directory Bs
  contents←⎕FIO[29] path

  →(1≤≡contents) ⍴ lsuccess
    ⍝ Failed to list PATH.
    contents←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lsuccess:
    contents←1 contents
  lswitch_end:
∇

⍝ Returns path of the current working directory.
⍝ ←path: maybe<string>.
∇path←FIO∆CURRENT_DIRECTORY
  ⍝ Zs ←    ⎕FIO 30        getcwd()
  path←⎕FIO 30

  →(1≤≡path) ⍴ lsuccess
    ⍝ Failed to list directory.
    path←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lsuccess:
    path←1 path
  lswitch_end:
∇

⍝ Creates a directory at the given path if it doesn't exist. Does not recurse.
⍝ →mode: vector<uint> - octal mode for the directory (i.e. 7 5 5.)
⍝ →path: string.
⍝ ←success: maybe<void>.
∇success←mode FIO∆MAKE_DIRECTORY path
  →(FIO∆IS_FILE path) ⍴ lis_file
  ⍝ Zi ← Ai ⎕FIO[20] Bh    mkdir(Bc, AI)
  success←path ⎕FIO[20]⍨ 8⊥mode
  →(0≡success) ⍴ lsuccess
    ⍝ Failed to make directory.
    success←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lis_file:
    success←0 "Path already exists and is a file" ◊ →lswitch_end
  lsuccess:
    success←⍬,1
  lswitch_end:
∇

⍝ Creates a directory at the given path and it's parent directories if they
⍝ don't exist.
⍝ →mode: vector<uint> - octal mode for the directory as an integer vector (i.e.
⍝ 7 5 5.)
⍝ →path: string.
⍝ ←success: maybe<void>.
∇success←mode FIO∆MAKE_DIRECTORIES path; directories
  directories←FIO∆JOIN_PATH\ FIO∆SPLIT_PATH path
  →(0≡≢directories) ⍴ linvalid_path

  success←↑directories FIO∆MAKE_DIRECTORY⍨¨ (≢directories)/⊂mode

  →lsuccess
linvalid_path:
  success←0 "Invalid path"
lsuccess:
∇

⍝ Common file descriptors.
⍝ Type: fd.
FIO∆stdin←0
⍝ Type: fd.
FIO∆stdout←1
⍝ Type: fd.
FIO∆stderr←2

⍝ Returns open file descriptors.
⍝ ←fds: vector<fd>.
∇fds←FIO∆LIST_FDS
  ⍝ ⎕FIO     0     return a list of open file descriptors
  fds←⎕FIO 0
∇

⍝ Checks if a file (not a directory) exists at the given path and can be opened.
⍝ NOTE: if you plan on opening the file, just use FIO∆OPEN_FILE.
⍝ →path: string.
⍝ ←result: boolean.
∇result←FIO∆IS_FILE path; fd
  →(↑FIO∆LIST_DIRECTORY path) ⍴ lis_directory
  fd←"r" FIO∆OPEN_FILE path ◊ →(↑fd) ⍴ lis_file
    ⍝ An error occured, probably not a file.
    result←0 ◊ →lswitch_end
  lis_directory:
    result←0 ◊ →lswitch_end
  lis_file:
    ⊣ FIO∆CLOSE_FD ↑1↓fd
    result←1
  lswitch_end:
∇

⍝ Opens a file.
⍝ →mode: string - open mode (i.e. "w", "r+", etc..). See 'man fopen' for
⍝ details.
⍝ →path: string.
⍝ ←fd: maybe<fd> - the descriptor of the opened file.
∇fd←mode FIO∆OPEN_FILE path
  ⍝ Zh ← As ⎕FIO[ 3] Bs    fopen(Bs, As) filename Bs mode As
  fd←mode ⎕FIO[3] path

  →(1≤fd) ⍴ lsuccess
    fd←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lfail
  lsuccess:
    fd←1 fd
  lfail:
∇

⍝ Closes a file descriptor.
⍝ →fd: fd.
⍝ ←success: maybe<void>.
∇success←FIO∆CLOSE_FD fd
  →(~fd∊FIO∆LIST_FDS) ⍴ lunopen_fd
  ⍝ Ze ←    ⎕FIO[ 4] Bh    fclose(Bh)
  success←⎕FIO[4] fd
  →(0≡success) ⍴ lsuccess
    ⍝ Failed to close fd.
    success←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lunopen_fd:
    success←0 "Not an open file descriptor" ◊ →lswitch_end
  lsuccess:
    success←⍬,1
  lswitch_end:
∇

⍝ Returns whether EOF was reached for the file descriptor. If the file
⍝ descriptor is not open, returns true.
⍝ →fd: fd.
⍝ ←eof_reached: boolean.
∇eof_reached←FIO∆EOF_FD fd
  →(~fd∊FIO∆LIST_FDS) ⍴ lunopen_fd
  ⍝ Zi ←    ⎕FIO[10] Bh    feof(Bh).
  eof_reached←0≢(⎕FIO[10] fd)

  →lsuccess
lunopen_fd:
  eof_reached←1
lsuccess:
∇

⍝ Returns whether an error ocurred with the file descriptor. If the file
⍝ descriptor is not open, returns true.
⍝ →fd: fd.
⍝ ←has_error: boolean.
∇has_error←FIO∆ERROR_FD fd
  →(~fd∊FIO∆LIST_FDS) ⍴ lunopen_fd
  ⍝ Ze ←    ⎕FIO[11] Bh    ferror(Bh)
  has_error←0≢(⎕FIO[11] fd)

  →lsuccess
lunopen_fd:
  has_error←1
lsuccess:
∇

⍝ Reads bytes up to specified number of bytes from the file descriptor.
⍝ →maximum_bytes: uint - the maximum number of bytes to read.
⍝ →fd: fd.
⍝ ←bytes: maybe<bytes>.
∇bytes←fd FIO∆READ_FD maximum_bytes
  →(~fd∊FIO∆LIST_FDS) ⍴ lunopen_fd
  ⍝ Zb ← Ai ⎕FIO[ 6] Bh    fread(Zi, 1, Ai, Bh) 1 byte per Zb
  bytes←maximum_bytes ⎕FIO[6] fd
  →(0≢bytes) ⍴ lsuccess
    ⍝ Failed to read fd.
    bytes←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lunopen_fd:
    bytes←0 "Not an open file descriptor" ◊ →lswitch_end
  lsuccess:
    bytes←1 bytes
  lswitch_end:
∇

⍝ Reads bytes up to a newline or EOF. Newlines are not included in the output.
⍝ →fd: fd.
⍝ ←bytes: maybe<bytes>.
∇bytes←FIO∆READ_LINE_FD fd; newline;buffer
  →(fd∊FIO∆LIST_FDS) ⍴ lopen_fd
    bytes←0 "Not an open file descriptor" ◊ →lend
  lopen_fd:
  →(~FIO∆EOF_FD fd) ⍴ lnot_eof
    bytes←0 "Reached EOF" ◊ →lend
  lnot_eof:

  bytes←⍬
  newline←FIO∆UTF8_TO_BYTES "\n"
  lread_loop:
    ⍝ Zb ← Ai ⎕FIO[ 8] Bh    fgets(Zb, Ai, Bh) 1 byte per Zb
    buffer←5000 ⎕FIO[8] fd
    →(0≡≢buffer) ⍴ lread_loop_end
    bytes←bytes,buffer
    →(newline≢¯1↑bytes) ⍴ lno_newline
      bytes←¯1↓bytes ◊ →lread_loop_end
    lno_newline:
    →lread_loop
  lread_loop_end:

  →(0≢≢bytes) ⍴ lread_success
    bytes←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lend
  lread_success:

  bytes←1 bytes

lend:
∇

⍝ Reads bytes from a file descriptor until EOF is reached.
⍝ →fd: fd.
⍝ ←bytes: maybe<bytes>.
∇bytes←FIO∆READ_ENTIRE_FD fd; buffer
  →(~FIO∆EOF_FD fd) ⍴ lnot_eof
    bytes←0 "Reached EOF" ◊ →lend
  lnot_eof:

  bytes←⍬
  lread_loop:
    buffer←fd FIO∆READ_FD 5000
    →(~↑buffer) ⍴ lend_read_loop
    bytes←bytes,↑1↓buffer ◊ →lread_loop
  lend_read_loop:

  →(~FIO∆ERROR_FD fd) ⍴ lsuccess
    bytes←0 bytes ◊ →lfail
  lsuccess:
    bytes←1 bytes
  lfail:

lend:
∇

⍝ Reads in an entire file as bytes.
⍝ →path: string.
⍝ ←bytes: maybe<bytes>.
∇bytes←FIO∆READ_ENTIRE_FILE path
  ⍝ Zb ←    ⎕FIO[26] Bs    return entire file Bs as byte vector
  ⍝ ⎕FIO[26] throws an APL exception on directories, and probably some other
  ⍝ things.
  bytes←"→lexception" ⎕EA "⎕FIO[26] path"
  →(1≤≡bytes) ⍴ lsuccess
    ⍝ Failed to read file.
    bytes←0 "File does not exist" ◊ →lswitch_end
  lexception:
    bytes←0 "Either APL exception or not a file" ◊ →lswitch_end
  lsuccess:
    ⍝ ⎕FIO[26] actually returns a string of bytes, so ⎕UCS is used to convert
    ⍝ them to numbers.
    bytes←1 (⎕UCS bytes)
  lswitch_end:
∇

⍝ Writes bytes to the file descriptor.
⍝ →fd: fd.
⍝ →bytes: bytes.
⍝ ←success: maybe<void>.
∇success←fd FIO∆WRITE_FD bytes
  →(~fd∊FIO∆LIST_FDS) ⍴ lunopen_fd
  ⍝ Zi ← Ab ⎕FIO[ 7] Bh    fwrite(Ab, 1, ⍴Ai, Bh) 1 byte per Ai
  success←bytes ⎕FIO[7] fd
  →((≢bytes)≡success) ⍴ lsuccess
    ⍝ Failed to write to fd.
    success←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lunopen_fd:
    success←0 "Not an open file descriptor" ◊ →lswitch_end
  lsuccess:
    success←⍬,1
  lswitch_end:
∇

⍝ Prints a string out to a file descriptor.
⍝ →fd: fd.
⍝ ←success: string.
∇success←fd FIO∆PRINT_FD string
  success←fd FIO∆WRITE_FD FIO∆UTF8_TO_BYTES string
∇

⍝ Prints formatted output to a file descriptor, like C fprintf.
⍝ →fd: fd.
⍝ →format_arguments: vector<string, any...> - a vector with the format as the
⍝ first element, and the arguments as the rest.
⍝ ←bytes_written: maybe<uint> - the number of bytes written.
∇bytes_written←fd FIO∆PRINTF_FD format_arguments
  →(~fd∊FIO∆LIST_FDS) ⍴ lunopen_fd
  ⍝ Zi ← A  ⎕FIO[22] Bh    fprintf(Bh,     A1, A2...) format A1
  bytes_written←format_arguments ⎕FIO[22] fd
  →(0≤bytes_written) ⍴ lsuccess
    ⍝ Failed to write to fd.
    bytes_written←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lunopen_fd:
    bytes_written←0 "Not an open file descriptor"
    →lswitch_end
  lsuccess:
    bytes_written←1 bytes_written
  lswitch_end:
∇

⍝ If path points to a file, it will be unlinked, possibly deleting it.
⍝ If path points to a directory, it will be deleted if empty.
⍝ →path: string.
⍝ ←success: maybe<void>.
∇success←FIO∆REMOVE path
  →(↑FIO∆LIST_DIRECTORY path) ⍴ ldirectory
    ⍝ Zi ←    ⎕FIO[19] Bh    unlink(Bc)
    success←⎕FIO[19] path ◊ →lfile
  ldirectory:
    ⍝ Zi ←    ⎕FIO[21] Bh    rmdir(Bc)
    success←⎕FIO[21] path
  lfile:

  →(0≡success) ⍴ lsuccess
    ⍝ Failed to remove path.
    success←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lsuccess:
    success←⍬,1
  lswitch_end:
∇

⍝ If path points to a file, it will be unlinked, possibly deleting it.
⍝ If path points to a directory, it, and all of its contents, will be deleted.
⍝ →path: string.
⍝ ←success: maybe<void>.
∇success←FIO∆REMOVE_RECURSIVE path; contents;other_path
  contents←FIO∆LIST_DIRECTORY path
  →(~↑contents) ⍴ lis_not_directory
    contents←↑1↓contents
    ldelete_loop:
      →(0≡≢contents) ⍴ ldelete_loop_end
      other_path←path FIO∆JOIN_PATH ↑contents ◊ contents←1↓contents
      ⊣ FIO∆REMOVE_RECURSIVE other_path
      →ldelete_loop
    ldelete_loop_end:
  lis_not_directory:

  success←FIO∆REMOVE path
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Process Handling                                                             ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ TODO consider splitting out replacement algorithm.
⍝ Escapes the given shell argument with quotes.
⍝ →argument: string.
⍝ ←escaped_arugment: string.
∇escaped_arugment←FIO∆ESCAPE_SHELL_ARGUMENT argument
  escaped_arugment←"'",⍨"'",∊(argument,⍨⊂"'\\''")[1+(⍳⍨argument)×~argument∊"'"]
∇

⍝ Joins two shell arguments together with a space.
⍝ →front_argument: string.
⍝ →back_argument: string.
⍝ ←result: string.
∇result←front_argument FIO∆JOIN_SHELL_ARGUMENTS back_argument
  result←front_argument,' ',back_argument
∇

⍝ Runs the given command in the user's shell in a subprocess. Close with
⍝ FIO∆PCLOSE.
⍝ →exe_arguments: vector<string> - a vector with the executable to run as the
⍝ first element, and the arguments to it as the rest.
⍝ ←fd: maybe<fd> - the process' read-only file descriptor.
∇fd←FIO∆POPEN_READ exe_arguments
  ⍝ Zh ← As ⎕FIO[24] Bs    popen(Bs, As) command Bs mode As
  fd←"r" ⎕FIO[24] ↑FIO∆JOIN_SHELL_ARGUMENTS/ FIO∆ESCAPE_SHELL_ARGUMENT¨ exe_arguments

  →(1≤fd) ⍴ lsuccess
    ⍝ Failed to run popen.
    fd←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lsuccess:
    fd←1 fd
  lswitch_end:
∇

⍝ Runs the given command in the user's shell in a subprocess. Close with
⍝ FIO∆PCLOSE.
⍝ →exe_arguments: vector<string> - a vector with the executable to run as the
⍝ first element, and the arguments to it as the rest.
⍝ ←fd: maybe<fd> - The process' write-only file descriptor.
∇fd←FIO∆POPEN_WRITE exe_arguments
  ⍝ Zh ← As ⎕FIO[24] Bs    popen(Bs, As) command Bs mode As
  fd←"w" ⎕FIO[24] ↑FIO∆JOIN_SHELL_ARGUMENTS/ FIO∆ESCAPE_SHELL_ARGUMENT¨ exe_arguments

  →(1≤fd) ⍴ lsuccess
    ⍝ Failed to run popen.
    fd←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lsuccess:
    fd←1 fd
  lswitch_end:
∇

⍝ Closes a file descriptor opened with FIO∆POPEN_{READ,WRITE}.
⍝ →fd: fd.
⍝ ←error: maybe<uint> - process exit code.
∇error←FIO∆PCLOSE fd
  →(~fd∊FIO∆LIST_FDS) ⍴ lunopen_fd
  ⍝ Ze ←    ⎕FIO[25] Bh    pclose(Bh)
  error←⎕FIO[25] fd
  →(0≤error) ⍴ lsuccess
    ⍝ Failed to run pclose.
    error←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lunopen_fd:
    error←0 "Not an open file descriptor" ◊ →lswitch_end
  lsuccess:
    error←1 error
  lswitch_end:
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Time                                                                         ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ Returns the current time since the Epoch in seconds.
⍝ ←s: maybe<uint>.
∇s←FIO∆TIME_S
  ⍝ Zi ←    ⎕FIO[50] Bu    gettimeofday()
  s←⎕FIO[50] 1

  →(0≢s) ⍴ lsuccess
    ⍝ Failed to get time.
    s←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lsuccess:
    s←1 s
  lswitch_end:
∇

⍝ Returns the current time since the Epoch in milliseconds.
⍝ ←ms: maybe<uint>.
∇ms←FIO∆TIME_MS
  ⍝ Zi ←    ⎕FIO[50] Bu    gettimeofday()
  ms←⎕FIO[50] 1000

  →(0≢ms) ⍴ lsuccess
    ⍝ Failed to get time.
    ms←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lsuccess:
    ms←1 ms
  lswitch_end:
∇

⍝ Returns the current time since the Epoch in microseconds.
⍝ ←us: maybe<uint>.
∇us←FIO∆TIME_US
  ⍝ Zi ←    ⎕FIO[50] Bu    gettimeofday()
  us←⎕FIO[50] 1000000

  →(0≢us) ⍴ lsuccess
    ⍝ Failed to get time.
    us←0 (FIO∆STRERROR FIO∆ERRNO) ◊ →lswitch_end
  lsuccess:
    us←1 us
  lswitch_end:
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
