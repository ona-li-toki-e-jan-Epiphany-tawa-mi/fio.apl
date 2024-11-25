#!/usr/local/bin/apl --script

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

⍝ fio.apl unit testing script.

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Testing Functions                                                            ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ TODO document.
TEST_COUNT←0
SECTION_NAME←⍬
ASSERTION_NUMBER←0
TEST_FAILED←0
FAILED_TESTS←⍬

⍝ TODO document.
∇RUN TEST; RESULT
  TEST_COUNT←1+TEST_COUNT

  TEST_FAILED←0
  SECTION_NAME←⍬
  ASSERTION_NUMBER←0
  ⍞←"Runnning test '" ◊ ⍞←TEST ◊ ⍞←"'... "
  ⍎TEST

  →TEST_FAILED ⍴ LFAILED
    ⍞←"OK\n" ◊ →LNOT_FAILED
  LFAILED:
    ⍞←"FAIL\n"
    →(0≢≢SECTION_NAME) ⍴ LHAS_SECTION_NAME
      FAILED_TESTS←FAILED_TESTS,⊂TEST," assertion",ASSERTION_NUMBER
      →LNO_SECTION_NAME
    LHAS_SECTION_NAME:
      FAILED_TESTS←FAILED_TESTS,⊂TEST," section '",SECTION_NAME,"' assertion",ASSERTION_NUMBER
    LNO_SECTION_NAME:
  LNOT_FAILED:
∇

⍝ TODO document.
∇SECTION NAME
  SECTION_NAME←NAME
  ASSERTION_NUMBER←0
∇

⍝ TODO document.
∇FAILED←ASSERT RESULT
  →(0≡RESULT) ⍴ LVALID ◊ →(1≡RESULT) ⍴ LVALID
    ⍞←"\nASSERT: encounted unexpected result value. Expected a scalar 0 or 1, got"
    ⍞←": '" ◊ ⍞←RESULT ◊ ⍞←"'\n"
    ⍎")OFF 1"
  LVALID:

  ASSERTION_NUMBER←1+ASSERTION_NUMBER

  →TEST_FAILED ⍴ LALREADY_FAILED
  TEST_FAILED←~RESULT
LALREADY_FAILED:
  FAILED←TEST_FAILED
∇

⍝ TODO document.
ASSERT_R←"→(ASSERT RESULT) ⍴ LFAIL"

⍝ TODO document.
∇REPORT_TEST_FAILED TEST_NAME
  ⍞←" - " ◊ ⍞←TEST_NAME ◊ ⍞←"\n"
∇
∇REPORT; TESTS_PASSED
  TESTS_PASSED←TEST_COUNT-≢FAILED_TESTS
  ⍞←TESTS_PASSED ◊ ⍞←"/" ◊ ⍞←TEST_COUNT ◊ ⍞←" test(s) passed - "
  →(0≢≢FAILED_TESTS) ⍴ LTESTS_FAILED
    ⍞←"OK\n" ◊ →LTESTS_PASSED
  LTESTS_FAILED:
    ⍞←"FAIL\n"
    ⍞←"\nPlease review the following failed tests:\n"
    REPORT_TEST_FAILED¨ FAILED_TESTS
  LTESTS_PASSED:
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Tests                                                                        ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

∇TEST_UTF8_BYTES_CONVERSION; RESULT;STRING;BYTES
  SECTION "1"
  STRING←"This is a test"
  BYTES←84 104 105 115 32 105 115 32 97 32 116 101 115 116
  RESULT←BYTES≡FIO∆UTF8_TO_BYTES STRING ◊ ⍎ASSERT_R
  RESULT←STRING≡FIO∆BYTES_TO_UTF8 BYTES ◊ ⍎ASSERT_R

  SECTION "2"
  STRING←"Have you tried C-\\ APL-Z RET?"
  BYTES←72 97 118 101 32 121 111 117 32 116 114 105 101 100 32 67 45 92 32 65 80 76 45 90 32 82 69 84 63
  RESULT←BYTES≡FIO∆UTF8_TO_BYTES STRING ◊ ⍎ASSERT_R
  RESULT←STRING≡FIO∆BYTES_TO_UTF8 BYTES ◊ ⍎ASSERT_R

  SECTION "3"
  STRING←"Вы что, яйцо?"
  BYTES←208 146 209 139 32 209 135 209 130 208 190 44 32 209 143 208 185 209 134 208 190 63
  RESULT←BYTES≡FIO∆UTF8_TO_BYTES STRING ◊ ⍎ASSERT_R
  RESULT←STRING≡FIO∆BYTES_TO_UTF8 BYTES ◊ ⍎ASSERT_R

LFAIL:
∇

∇TEST_MISC; RESULT
  SECTION "Assumptions"
  RESULT←0≡FIO∆ERRNO                      ◊ ⍎ASSERT_R
  RESULT←"Success"≡FIO∆STRERROR FIO∆ERRNO ◊ ⍎ASSERT_R

LFAIL:
∇

∇TEST_SPLITTING_VECTORS; VECTOR;RESULT
  SECTION "Splitting number vector"
  VECTOR←1 1 2 2 3 3 4 4 5 5
  RESULT←(1 FIO∆SPLIT VECTOR)≡⍬ (2 2 3 3 4 4 5 5)        ◊ ⍎ASSERT_R
  RESULT←(2 FIO∆SPLIT VECTOR)≡(1 1) ⍬ (3 3 4 4 5 5)      ◊ ⍎ASSERT_R
  RESULT←(3 FIO∆SPLIT VECTOR)≡(1 1 2 2) ⍬ (4 4 5 5)      ◊ ⍎ASSERT_R
  RESULT←(4 FIO∆SPLIT VECTOR)≡(1 1 2 2 3 3) ⍬ (5 5)      ◊ ⍎ASSERT_R
  RESULT←(5 FIO∆SPLIT VECTOR)≡(1 1 2 2 3 3 4 4) ⍬ ⍬      ◊ ⍎ASSERT_R
  RESULT←(1 FIO∆SPLIT_CLEAN VECTOR)≡⍬,⊂(2 2 3 3 4 4 5 5) ◊ ⍎ASSERT_R
  RESULT←(2 FIO∆SPLIT_CLEAN VECTOR)≡(1 1) (3 3 4 4 5 5)  ◊ ⍎ASSERT_R
  RESULT←(3 FIO∆SPLIT_CLEAN VECTOR)≡(1 1 2 2) (4 4 5 5)  ◊ ⍎ASSERT_R
  RESULT←(4 FIO∆SPLIT_CLEAN VECTOR)≡(1 1 2 2 3 3) (5 5)  ◊ ⍎ASSERT_R
  RESULT←(5 FIO∆SPLIT_CLEAN VECTOR)≡⍬,⊂1 1 2 2 3 3 4 4   ◊ ⍎ASSERT_R

  SECTION "Splitting strings"
  VECTOR←"This is\na\n\ntest"
  RESULT←"This is" "a" (0⍴'') "test"≡"\n" FIO∆SPLIT VECTOR ◊ ⍎ASSERT_R
  RESULT←"This is" "a" "test"≡"\n" FIO∆SPLIT_CLEAN VECTOR  ◊ ⍎ASSERT_R
  VECTOR←"/bin:/usr/bin:/usr/local/bin"
  RESULT←"/bin" "/usr/bin" "/usr/local/bin"≡":" FIO∆SPLIT VECTOR
  ⍎ASSERT_R
  RESULT←"/bin" "/usr/bin" "/usr/local/bin"≡":" FIO∆SPLIT_CLEAN VECTOR
  ⍎ASSERT_R

LFAIL:
∇

∇TEST_DEFER; RESULT;A
  SECTION "Assumptions"
  RESULT←0≡≢FIO∆DEFERS ◊ ⍎ASSERT_R

  SECTION "FIO∆DEFER"
  A←1
  FIO∆DEFER "A←A+1" ◊ FIO∆DEFER "A←A÷2" ◊ FIO∆DEFER "A←A+5"
  RESULT←"A←A+5"≡↑FIO∆DEFERS[1] ◊ ⍎ASSERT_R
  RESULT←"A←A÷2"≡↑FIO∆DEFERS[2] ◊ ⍎ASSERT_R
  RESULT←"A←A+1"≡↑FIO∆DEFERS[3] ◊ ⍎ASSERT_R

  SECTION "FIO∆DEFER_END"
  FIO∆DEFER_END
  RESULT←4≡A           ◊ ⍎ASSERT_R
  RESULT←0≡≢FIO∆DEFERS ◊ ⍎ASSERT_R

LFAIL:
∇

∇TEST_PATH_HANDLING; RESULT
  SECTION "Path splitting"
  RESULT←("this" "is" "a" "test")≡FIO∆SPLIT_PATH "/this//////is/a///test"
  ⍎ASSERT_R
  RESULT←("fortune" "favors" "the" "brave")≡FIO∆SPLIT_PATH "fortune/favors//the/brave/"
  ⍎ASSERT_R
  RESULT←("infi" "nit" "e" "wis" "do" "m" "!")≡FIO∆SPLIT_PATH "///infi/nit/e//wis/do/m///!"
  ⍎ASSERT_R
  RESULT←("digg" ".." "y h" "." "ole")≡FIO∆SPLIT_PATH "digg/../y h/./ole"
  ⍎ASSERT_R

  SECTION "Path joining"
  RESULT←"this is/a test"≡"this is" FIO∆JOIN_PATH "a test"       ◊ ⍎ASSERT_R
  RESULT←"/after////market"≡"/after" FIO∆JOIN_PATH "///market"   ◊ ⍎ASSERT_R
  RESULT←"this/is/a/test"≡↑FIO∆JOIN_PATH/ "this" "is" "a" "test" ◊ ⍎ASSERT_R
  RESULT←"public/static/void/main/String[]/args"≡↑FIO∆JOIN_PATH/ "public" "static" "void" "main" "String[]" "args"
  ⍎ASSERT_R

LFAIL:
∇

∇TEST_DIRECTORY_HANDLING; RESULT;CONTENTS
  SECTION "Assumptions"
  RESULT←0≢FIO∆CURRENT_DIRECTORY  ◊ ⍎ASSERT_R
  RESULT←0≢≢FIO∆CURRENT_DIRECTORY ◊ ⍎ASSERT_R

  SECTION "Fail on files and nonexistant directories"
  RESULT←~↑FIO∆LIST_DIRECTORY "tests/existing-file"               ◊ ⍎ASSERT_R
  RESULT←~↑FIO∆LIST_DIRECTORY "tests/nonexisting-directory"       ◊ ⍎ASSERT_R
  RESULT←~↑7 5 5 FIO∆MAKE_DIRECTORY "tests/nonexisting/directory" ◊ ⍎ASSERT_R
  RESULT←~↑FIO∆REMOVE "tests/nonexisting-directory"               ◊ ⍎ASSERT_R

  SECTION "FIO∆LIST_DIRECTORY"
  CONTENTS←FIO∆LIST_DIRECTORY "tests/" ◊ RESULT←↑CONTENTS    ◊ ⍎ASSERT_R
  CONTENTS←↑CONTENTS[2] ◊ RESULT←CONTENTS≡⍬,⊂"existing-file" ◊ ⍎ASSERT_R

  SECTION "FIO∆MAKE_DIRECTORY"
  RESULT←↑7 5 5 FIO∆MAKE_DIRECTORY "tests/new-directory/" ◊ ⍎ASSERT_R
  RESULT←↑FIO∆LIST_DIRECTORY "tests/new-directory/"       ◊ ⍎ASSERT_R
  RESULT←↑FIO∆REMOVE "tests/new-directory/"               ◊ ⍎ASSERT_R
  RESULT←~↑FIO∆LIST_DIRECTORY "tests/new-directory/"      ◊ ⍎ASSERT_R

  ⍝ TODO reinstate
  ⍝SECTION "FIO∆MKDIRS and FIO∆RMDIRS"
  ⍝RESULT←0≡7 5 5 FIO∆MKDIRS "tests/this/is/a/test/" ◊ ⍎ASSERT_R
  ⍝RESULT←1≡FIO∆IS_DIRECTORY "tests/this/"           ◊ ⍎ASSERT_R
  ⍝RESULT←1≡FIO∆IS_DIRECTORY "tests/this/is/"        ◊ ⍎ASSERT_R
  ⍝RESULT←1≡FIO∆IS_DIRECTORY "tests/this/is/a/"      ◊ ⍎ASSERT_R
  ⍝RESULT←1≡FIO∆IS_DIRECTORY "tests/this/is/a/test/" ◊ ⍎ASSERT_R
  ⍝FD←"w" FIO∆FOPEN "tests/this/is/a/test/file"
  ⍝RESULT←1≤FD ◊ ⍎ASSERT_R
  ⍝RESULT←(≢EXISTING_FILE_CONTENTS)≡FD FIO∆FWRITE⍨ FIO∆UTF8_TO_BYTES EXISTING_FILE_CONTENTS
  ⍝⍎ASSERT_R ◊ RESULT←0≡FIO∆FCLOSE FD ◊ ⍎ASSERT_R
  ⍝RESULT←0≡FIO∆RMDIRS "tests/this"                  ◊ ⍎ASSERT_R
  ⍝RESULT←0≡FIO∆IS_DIRECTORY "tests/this/"           ◊ ⍎ASSERT_R

LFAIL:
∇

∇TEST_FILE_HANDLING; FILE;FILE_CONTENTS;FILE_CONTENTS_LINES;RESULT;FD;CONTENTS;BUFFER;BYTES_WRITTEN
  FILE←"tests/existing-file"
  FILE_CONTENTS←"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  FILE_CONTENTS_LINES←"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat." "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

  SECTION "Assumptions"
  RESULT←0≡FIO∆STDIN                                    ◊ ⍎ASSERT_R
  RESULT←1≡FIO∆STDOUT                                   ◊ ⍎ASSERT_R
  RESULT←2≡FIO∆STDERR                                   ◊ ⍎ASSERT_R
  RESULT←3≡≢FIO∆LIST_FDS                                ◊ ⍎ASSERT_R
  RESULT←∧/FIO∆LIST_FDS∊FIO∆STDIN FIO∆STDOUT FIO∆STDERR ◊ ⍎ASSERT_R

  SECTION "Fail on non-existant file/fd"
  FD←100
  RESULT←~↑"r" FIO∆OPEN_FILE "tests/nonexisting-file"    ◊ ⍎ASSERT_R
  RESULT←~↑FIO∆CLOSE_FD FD                               ◊ ⍎ASSERT_R
  RESULT←~↑500 FIO∆READ_FD FD                            ◊ ⍎ASSERT_R
  RESULT←~↑500 FIO∆READ_LINE_FD FD                       ◊ ⍎ASSERT_R
  RESULT←~↑FIO∆READ_ENTIRE_FD FD                         ◊ ⍎ASSERT_R
  RESULT←~↑FIO∆READ_ENTIRE_FILE "tests/nonexisting-file" ◊ ⍎ASSERT_R
  RESULT←~↑FIO∆WRITE_FD FD                               ◊ ⍎ASSERT_R
  RESULT←~↑FIO∆REMOVE "tests/nonexisting-file"           ◊ ⍎ASSERT_R
  RESULT←~↑FIO∆FPRINTF FD                                ◊ ⍎ASSERT_R

  SECTION "FIO∆OPEN_FILE & FIO∆CLOSE_FD"
  FD←"r" FIO∆OPEN_FILE FILE ◊ RESULT←↑FD ◊ ⍎ASSERT_R ◊ FD←FD[2]
  RESULT←↑FIO∆CLOSE_FD FD ◊ ⍎ASSERT_R

  SECTION "FIO∆READ_FD"
  FD←"r" FIO∆OPEN_FILE FILE ◊ RESULT←↑FD ◊ ⍎ASSERT_R ◊ FD←FD[2]
  CONTENTS←⍬
  LREAD_LOOP:
    BUFFER←500 FIO∆READ_FD FD
    →(~↑BUFFER) ⍴ LREAD_LOOP_END
    CONTENTS←CONTENTS,↑BUFFER[2]
  LREAD_LOOP_END:
  RESULT←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 CONTENTS ◊ ⍎ASSERT_R
  RESULT←~↑500 FIO∆READ_FD FD                     ◊ ⍎ASSERT_R
  RESULT←↑FIO∆CLOSE_FD FD                         ◊ ⍎ASSERT_R

  SECTION "FIO∆READ_LINE_FD"
  FD←"r" FIO∆OPEN_FILE FILE ◊ RESULT←↑FD ◊ ⍎ASSERT_R ◊ FD←FD[2]
  CONTENTS←⍬
  BUFFER←500 FIO∆READ_LINE_FD FD ◊ RESULT←↑BUFFER                 ◊ ⍎ASSERT_R
  BUFFER←↑BUFFER[2] ◊ CONTENTS←CONTENTS,BUFFER
  RESULT←(FIO∆BYTES_TO_UTF8 BUFFER)≡"\n",⍨↑FILE_CONTENTS_LINES[1] ◊ ⍎ASSERT_R
  BUFFER←500 FIO∆READ_LINE_FD FD ◊ RESULT←↑BUFFER                 ◊ ⍎ASSERT_R
  BUFFER←↑BUFFER[2] ◊ CONTENTS←CONTENTS,BUFFER
  RESULT←(FIO∆BYTES_TO_UTF8 BUFFER)≡"\n",⍨↑FILE_CONTENTS_LINES[2] ◊ ⍎ASSERT_R
  BUFFER←500 FIO∆READ_LINE_FD FD ◊ RESULT←↑BUFFER                 ◊ ⍎ASSERT_R
  BUFFER←↑BUFFER[2] ◊ CONTENTS←CONTENTS,BUFFER
  RESULT←(FIO∆BYTES_TO_UTF8 BUFFER)≡"\n",⍨↑FILE_CONTENTS_LINES[3] ◊ ⍎ASSERT_R
  BUFFER←500 FIO∆READ_LINE_FD FD ◊ RESULT←↑BUFFER                 ◊ ⍎ASSERT_R
  BUFFER←↑BUFFER[2] ◊ CONTENTS←CONTENTS,BUFFER
  RESULT←(FIO∆BYTES_TO_UTF8 BUFFER)≡↑FILE_CONTENTS_LINES[4]       ◊ ⍎ASSERT_R
  RESULT←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 CONTENTS                 ◊ ⍎ASSERT_R
  RESULT←~↑500 FIO∆READ_LINE_FD FD                                ◊ ⍎ASSERT_R
  RESULT←↑FIO∆CLOSE_FD FD                                         ◊ ⍎ASSERT_R

  SECTION "FIO∆READ_ENTIRE_FD"
  FD←"r" FIO∆OPEN_FILE FILE ◊ RESULT←↑FD ◊ ⍎ASSERT_R  ◊ FD←FD[2]
  CONTENTS←FIO∆READ_ENTIRE_FD FD ◊ RESULT←↑CONTENTS   ◊ ⍎ASSERT_R
  RESULT←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 ↑CONTENTS[2] ◊ ⍎ASSERT_R
  RESULT←~↑500 FIO∆READ_FD FD                         ◊ ⍎ASSERT_R
  RESULT←↑FIO∆CLOSE_FD FD                             ◊ ⍎ASSERT_R

  SECTION "FIO∆READ_ENTIRE_FILE"
  RESULT←~↑FIO∆READ_ENTIRE_FILE "tests/" ◊ ⍎ASSERT_R
  ⍝ ^ Fail on directory.
  CONTENTS←FIO∆READ_ENTIRE_FILE FILE ◊ ⍎ASSERT_R ◊ RESULT←↑CONTENTS ◊ ⍎ASSERT_R
  RESULT←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 ↑CONTENTS[2] ◊ ⍎ASSERT_R

  SECTION "FIO∆WRITE_FD"
  FD←"w" FIO∆OPEN_FILE "tests/new-file" ◊ RESULT←↑FD ◊ ⍎ASSERT_R ◊ FD←FD[2]
  RESULT←↑FD FIO∆WRITE_FD⍨ FIO∆UTF8_TO_BYTES FILE_CONTENTS ◊ ⍎ASSERT_R
  RESULT←↑FIO∆CLOSE_FD FD                                  ◊ ⍎ASSERT_R
  CONTENTS←FIO∆READ_ENTIRE_FILE "tests/new-file"           ◊ ⍎ASSERT_R
  RESULT←↑CONTENTS                                         ◊ ⍎ASSERT_R
  RESULT←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 ↑CONTENTS[2]      ◊ ⍎ASSERT_R
  RESULT←↑FIO∆REMOVE "tests/new-file"                      ◊ ⍎ASSERT_R

  SECTION "FIO∆FPRINTF"
  FD←"w" FIO∆OPEN_FILE "tests/new-file" ◊ RESULT←↑FD ◊ ⍎ASSERT_R ◊ FD←FD[2]
  BYTES_WRITTEN←FD FIO∆FPRINTF⍨ "%s" FILE_CONTENTS
  RESULT←↑BYTES_WRITTEN ◊ ⍎ASSERT_R ◊ BYTES_WRITTEN←↑BYTES_WRITTEN[2]
  RESULT←(≢FILE_CONTENTS)≡BYTES_WRITTEN               ◊ ⍎ASSERT_R
  RESULT←↑FIO∆CLOSE_FD FD                             ◊ ⍎ASSERT_R
  RESULT←↑CONTENTS                                    ◊ ⍎ASSERT_R
  RESULT←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 ↑CONTENTS[2] ◊ ⍎ASSERT_R
  RESULT←↑FIO∆REMOVE "tests/new-file"                 ◊ ⍎ASSERT_R

LFAIL:
∇

∇TEST_PROCESS_HANDLING; RESULT;APL_PATH;COMMAND;FD;OUTPUT
  SECTION "FIO∆ESCAPE_SHELL_ARGUMENT"
  RESULT←"''"≡FIO∆ESCAPE_SHELL_ARGUMENT ""
  ⍎ASSERT_R
  RESULT←"'this is a test'"≡FIO∆ESCAPE_SHELL_ARGUMENT "this is a test"
  ⍎ASSERT_R
  RESULT←"'rot -F p'"≡FIO∆ESCAPE_SHELL_ARGUMENT "rot -F p"
  ⍎ASSERT_R
  RESULT←"'Today'\\''s the day'"≡FIO∆ESCAPE_SHELL_ARGUMENT "Today's the day"
  ⍎ASSERT_R
  RESULT←("'test'" "'text'" "'--option'" "'it'\\''s'")≡FIO∆ESCAPE_SHELL_ARGUMENT¨ "test" "text" "--option" "it's"
  ⍎ASSERT_R

  SECTION "Fail on non-existant fd"
  FD←100
  RESULT←~↑FIO∆PCLOSE FD ◊ ⍎ASSERT_R

  SECTION "FIO∆JOIN_SHELL_ARGUMENTS"
  RESULT←"'This is' 'a test'"≡"'This is'" FIO∆JOIN_SHELL_ARGUMENTS "'a test'"
  ⍎ASSERT_R
  RESULT←"these are some arugments"≡↑FIO∆JOIN_SHELL_ARGUMENTS/"these" "are" "some" "arugments"
  ⍎ASSERT_R

  SECTION "FIO∆POPEN_READ"
  APL_PATH←↑⎕ARG
  COMMAND←APL_PATH "--script" "--LX" '⍞←"Hello World!" ◊ ⍎")OFF"'
  FD←FIO∆POPEN_READ COMMAND ◊ RESULT←↑FD ◊ ⍎ASSERT_R ◊ FD←FD[2]
  OUTPUT←FIO∆READ_ENTIRE_FD FD ◊ RESULT←↑OUTPUT ◊ ⍎ASSERT_R ◊ OUTPUT←↑OUTPUT[2]
  RESULT←"Hello World!\n"≡FIO∆BYTES_TO_UTF8 OUTPUT ◊ ⍎ASSERT_R
  OUTPUT←FIO∆PCLOSE FD ◊ RESULT←↑OUTPUT ◊ ⍎ASSERT_R ◊ OUTPUT←OUTPUT[2]
  RESULT←0≡OUTPUT ◊ ⍎ASSERT_R

LFAIL:
∇

∇TEST_TIME; RESULT;S;MS;US;TIME
  SECTION "Fetch current time"
  S←FIO∆TIME_S   ◊ RESULT←↑S  ◊ ⍎ASSERT_R ◊ S←S[2]
  MS←FIO∆TIME_MS ◊ RESULT←↑MS ◊ ⍎ASSERT_R ◊ MS←MS[2]
  US←FIO∆TIME_US ◊ RESULT←↑US ◊ ⍎ASSERT_R ◊ US←US[2]

  SECTION "Time should increase"
  TIME←FIO∆TIME_S ◊ RESULT←↑TIME ◊ ⍎ASSERT_R ◊ TIME←TIME[2]
  RESULT←S≤TIME ◊ ⍎ASSERT_R
  TIME←FIO∆TIME_MS ◊ RESULT←↑TIME ◊ ⍎ASSERT_R ◊ TIME←TIME[2]
  RESULT←MS≤TIME ◊ ⍎ASSERT_R
  TIME←FIO∆TIME_US ◊ RESULT←↑TIME ◊ ⍎ASSERT_R ◊ TIME←TIME[2]
  RESULT←US≤TIME ◊ ⍎ASSERT_R

LFAIL:
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Test Runner                                                                  ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

)COPY ./fio.apl
⍞←" ^ Output of )COPY. Unimportant, please ignore\n\n"

∇MAIN
  RUN "TEST_UTF8_BYTES_CONVERSION"
  RUN "TEST_MISC"
  RUN "TEST_SPLITTING_VECTORS"
  RUN "TEST_DEFER"
  RUN "TEST_PATH_HANDLING"
  RUN "TEST_DIRECTORY_HANDLING"
  RUN "TEST_FILE_HANDLING"
  RUN "TEST_PROCESS_HANDLING"
  RUN "TEST_TIME"
  ⍞←"\n" ◊ REPORT
∇
MAIN

)OFF
