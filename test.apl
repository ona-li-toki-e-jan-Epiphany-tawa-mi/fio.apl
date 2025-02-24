#!/usr/local/bin/apl --script

⍝ This file is part of aplwiz.
⍝
⍝ Copyright (c) 2024-2025 ona-li-toki-e-jan-Epiphany-tawa-mi
⍝
⍝ aplwiz is free software: you can redistribute it and/or modify it under the
⍝ terms of the GNU General Public License as published by the Free Software
⍝ Foundation, either version 3 of the License, or (at your option) any later
⍝ version.
⍝
⍝ aplwiz is distributed in the hope that it will be useful, but WITHOUT ANY
⍝ WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
⍝ A PARTICULAR PURPOSE. See the GNU General Public License for more details.
⍝
⍝ You should have received a copy of the GNU General Public License along with
⍝ aplwiz. If not, see <https://www.gnu.org/licenses/>.

⍝ Original source:
⍝ - paltepuk - https://http://paltepuk.xyz/cgit/aplwiz.git/about/
⍝ - paltepuk (I2P) - http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p/cgit/aplwiz.git/about/
⍝ - paltepuk (Tor) - http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion/cgit/aplwiz.git/about/
⍝ - GitHub - https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/aplwiz/

⍝ Data types:
⍝ - string - a character vector.
⍝ - boolean - a scalar 0, for false, or a 1, for true.

⍝ fio.apl unit testing script.

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Testing Functions                                                            ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ The number of tests called with RUN.
⍝ Type: scalar whole number.
test_count←0
⍝ Whether the current test with RUN failed.
⍝ Type: scalar whole number.
test_failed←0
⍝ The section name to display for failed assertions. ⍬ means no section.
⍝ Type: scalar whole number.
section_name←⍬
⍝ Counters.
⍝ Type: scalar whole number.
assertion_number←0
⍝ Type: scalar whole number.
failed_tests←⍬

⍝ Runs the given test. Must be used to call functions with SECTION and ASSERT.
⍝ →test: string - the test function to run.
∇RUN test; result
  test_count←1+test_count

  test_failed←0
  section_name←⍬
  assertion_number←0
  ⍞←"Runnning test '" ◊ ⍞←test ◊ ⍞←"'... "
  ⍎test

  →test_failed ⍴ lfailed
    ⍞←"OK\n" ◊ →lnot_failed
  lfailed:
    ⍞←"FAIL\n"
    →(0≢≢section_name) ⍴ lhas_section_name
      failed_tests←failed_tests,⊂test," assertion",assertion_number
      →lno_section_name
    lhas_section_name:
      failed_tests←failed_tests,⊂test," section '",section_name,"' assertion",assertion_number
    lno_section_name:
  lnot_failed:
∇

⍝ Sets the current section name, which is displayed when assertions fail.
⍝ →name: string.
∇SECTION name
  section_name←name
  assertion_number←0
∇

⍝ Asserts that result is true.
⍝ →result: boolean.
⍝ ←failed: boolean - opposite of result.
∇failed←ASSERT result
  →(0≡result) ⍴ lvalid ◊ →(1≡result) ⍴ lvalid
    ⍞←"\nASSERT: encounted unexpected result value. Expected a scalar 0 or 1, got"
    ⍞←": '" ◊ ⍞←result ◊ ⍞←"'\n"
    ⍎")OFF 1"
  lvalid:

  assertion_number←1+assertion_number

  →test_failed ⍴ lalready_failed
  test_failed←~result
lalready_failed:
  failed←test_failed
∇

⍝ Macro for asserting a value in result.
⍝ Type: string.
massert←"→(ASSERT result) ⍴ lfail"

⍝ Prints out the final report for the tests.
∇REPORT; tests_passed
  tests_passed←test_count-≢failed_tests
  ⍞←tests_passed ◊ ⍞←"/" ◊ ⍞←test_count ◊ ⍞←" test(s) passed - "
  →(0≢≢failed_tests) ⍴ ltests_failed
    ⍞←"OK\n" ◊ →ltests_passed
  ltests_failed:
    ⍞←"FAIL\n"
    ⍞←"\nPlease review the following failed tests:\n"
    REPORT_TEST_FAILED¨ failed_tests
  ltests_passed:
∇
∇REPORT_TEST_FAILED test_name
  ⍞←" - " ◊ ⍞←test_name ◊ ⍞←"\n"
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Tests                                                                        ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

∇TEST_UTF8_BYTES_CONVERSION; result;STRING;BYTES
  SECTION "1"
  STRING←"This is a test"
  BYTES←84 104 105 115 32 105 115 32 97 32 116 101 115 116
  result←BYTES≡FIO∆UTF8_TO_BYTES STRING ◊ ⍎massert
  result←STRING≡FIO∆BYTES_TO_UTF8 BYTES ◊ ⍎massert

  SECTION "2"
  STRING←"Have you tried C-\\ APL-Z RET?"
  BYTES←72 97 118 101 32 121 111 117 32 116 114 105 101 100 32 67 45 92 32 65 80 76 45 90 32 82 69 84 63
  result←BYTES≡FIO∆UTF8_TO_BYTES STRING ◊ ⍎massert
  result←STRING≡FIO∆BYTES_TO_UTF8 BYTES ◊ ⍎massert

  SECTION "3"
  STRING←"Вы что, яйцо?"
  BYTES←208 146 209 139 32 209 135 209 130 208 190 44 32 209 143 208 185 209 134 208 190 63
  result←BYTES≡FIO∆UTF8_TO_BYTES STRING ◊ ⍎massert
  result←STRING≡FIO∆BYTES_TO_UTF8 BYTES ◊ ⍎massert

lfail:
∇

∇TEST_MISC; result
  SECTION "Assumptions"
  result←0≡FIO∆ERRNO                      ◊ ⍎massert
  result←"Success"≡FIO∆STRERROR FIO∆ERRNO ◊ ⍎massert

lfail:
∇

∇TEST_SPLITTING_VECTORS; VECTOR;result
  SECTION "Splitting number vector"
  VECTOR←1 1 2 2 3 3 4 4 5 5
  result←(1 FIO∆SPLIT VECTOR)≡⍬ (2 2 3 3 4 4 5 5)        ◊ ⍎massert
  result←(2 FIO∆SPLIT VECTOR)≡(1 1) ⍬ (3 3 4 4 5 5)      ◊ ⍎massert
  result←(3 FIO∆SPLIT VECTOR)≡(1 1 2 2) ⍬ (4 4 5 5)      ◊ ⍎massert
  result←(4 FIO∆SPLIT VECTOR)≡(1 1 2 2 3 3) ⍬ (5 5)      ◊ ⍎massert
  result←(5 FIO∆SPLIT VECTOR)≡(1 1 2 2 3 3 4 4) ⍬ ⍬      ◊ ⍎massert
  result←(1 FIO∆SPLIT_CLEAN VECTOR)≡⍬,⊂(2 2 3 3 4 4 5 5) ◊ ⍎massert
  result←(2 FIO∆SPLIT_CLEAN VECTOR)≡(1 1) (3 3 4 4 5 5)  ◊ ⍎massert
  result←(3 FIO∆SPLIT_CLEAN VECTOR)≡(1 1 2 2) (4 4 5 5)  ◊ ⍎massert
  result←(4 FIO∆SPLIT_CLEAN VECTOR)≡(1 1 2 2 3 3) (5 5)  ◊ ⍎massert
  result←(5 FIO∆SPLIT_CLEAN VECTOR)≡⍬,⊂1 1 2 2 3 3 4 4   ◊ ⍎massert

  SECTION "Splitting strings"
  VECTOR←"This is\na\n\ntest"
  result←"This is" "a" (0⍴'') "test"≡"\n" FIO∆SPLIT VECTOR ◊ ⍎massert
  result←"This is" "a" "test"≡"\n" FIO∆SPLIT_CLEAN VECTOR  ◊ ⍎massert
  VECTOR←"/bin:/usr/bin:/usr/local/bin"
  result←"/bin" "/usr/bin" "/usr/local/bin"≡":" FIO∆SPLIT VECTOR
  ⍎massert
  result←"/bin" "/usr/bin" "/usr/local/bin"≡":" FIO∆SPLIT_CLEAN VECTOR
  ⍎massert

lfail:
∇

∇TEST_PATH_HANDLING; result
  SECTION "Path splitting"
  result←("this" "is" "a" "test")≡FIO∆SPLIT_PATH "/this//////is/a///test"
  ⍎massert
  result←("fortune" "favors" "the" "brave")≡FIO∆SPLIT_PATH "fortune/favors//the/brave/"
  ⍎massert
  result←("infi" "nit" "e" "wis" "do" "m" "!")≡FIO∆SPLIT_PATH "///infi/nit/e//wis/do/m///!"
  ⍎massert
  result←("digg" ".." "y h" "." "ole")≡FIO∆SPLIT_PATH "digg/../y h/./ole"
  ⍎massert

  SECTION "Path joining"
  result←"this is/a test"≡"this is" FIO∆JOIN_PATH "a test"       ◊ ⍎massert
  result←"/after////market"≡"/after" FIO∆JOIN_PATH "///market"   ◊ ⍎massert
  result←"this/is/a/test"≡↑FIO∆JOIN_PATH/ "this" "is" "a" "test" ◊ ⍎massert
  result←"public/static/void/main/String[]/args"≡↑FIO∆JOIN_PATH/ "public" "static" "void" "main" "String[]" "args"
  ⍎massert

lfail:
∇

∇TEST_DIRECTORY_HANDLING; result;CONTENTS;FD
  SECTION "Assumptions"
  result←0≢FIO∆CURRENT_DIRECTORY  ◊ ⍎massert
  result←0≢≢FIO∆CURRENT_DIRECTORY ◊ ⍎massert

  SECTION "Fail on files and nonexistant directories"
  result←~↑FIO∆LIST_DIRECTORY "tests/existing-file"               ◊ ⍎massert
  result←~↑FIO∆LIST_DIRECTORY "tests/nonexisting-directory"       ◊ ⍎massert
  result←~↑7 5 5 FIO∆MAKE_DIRECTORY "tests/existing-file"         ◊ ⍎massert
  result←~↑7 5 5 FIO∆MAKE_DIRECTORY "tests/nonexisting/directory" ◊ ⍎massert
  result←~↑FIO∆REMOVE "tests/nonexisting-directory"               ◊ ⍎massert
  result←~↑FIO∆REMOVE_RECURSIVE "tests/nonexisting-directory"     ◊ ⍎massert

  SECTION "FIO∆LIST_DIRECTORY"
  CONTENTS←FIO∆LIST_DIRECTORY "tests/" ◊ result←↑CONTENTS   ◊ ⍎massert
  CONTENTS←↑1↓CONTENTS ◊ result←CONTENTS≡⍬,⊂"existing-file" ◊ ⍎massert

  SECTION "FIO∆MAKE_DIRECTORY"
  result←↑7 5 5 FIO∆MAKE_DIRECTORY "tests/new-directory/" ◊ ⍎massert
  result←↑FIO∆LIST_DIRECTORY "tests/new-directory/"       ◊ ⍎massert
  result←↑FIO∆REMOVE "tests/new-directory/"               ◊ ⍎massert
  result←~↑FIO∆LIST_DIRECTORY "tests/new-directory/"      ◊ ⍎massert

  SECTION "FIO∆MAKE_DIRECTORIES and FIO∆RMDIRS"
  result←↑7 5 5 FIO∆MAKE_DIRECTORIES "tests/this/is/a/test/" ◊ ⍎massert
  result←↑FIO∆LIST_DIRECTORY "tests/this/"                   ◊ ⍎massert
  result←↑FIO∆LIST_DIRECTORY "tests/this/is/"                ◊ ⍎massert
  result←↑FIO∆LIST_DIRECTORY "tests/this/is/a/"              ◊ ⍎massert
  result←↑FIO∆LIST_DIRECTORY "tests/this/is/a/test/"         ◊ ⍎massert
  FD←"w" FIO∆OPEN_FILE "tests/this/is/a/test/file"
  result←↑FD ◊ ⍎massert ◊ FD←↑1↓FD
  result←↑FD FIO∆WRITE_FD FIO∆UTF8_TO_BYTES "Hello, World!" ◊ ⍎massert
  result←↑FIO∆CLOSE_FD FD                                   ◊ ⍎massert
  result←↑FIO∆REMOVE_RECURSIVE "tests/this"                 ◊ ⍎massert
  result←~↑FIO∆LIST_DIRECTORY "tests/this/"                 ◊ ⍎massert

lfail:
∇

∇TEST_FILE_HANDLING; FILE;FILE_CONTENTS;FILE_CONTENTS_LINES;result;FD;CONTENTS;BUFFER;BYTES_WRITTEN
  FILE←"tests/existing-file"
  FILE_CONTENTS←"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  FILE_CONTENTS_LINES←"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat." "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

  SECTION "Assumptions"
  result←0≡FIO∆STDIN                                    ◊ ⍎massert
  result←1≡FIO∆STDOUT                                   ◊ ⍎massert
  result←2≡FIO∆STDERR                                   ◊ ⍎massert
  result←3≡≢FIO∆LIST_FDS                                ◊ ⍎massert
  result←∧/FIO∆LIST_FDS∊FIO∆STDIN FIO∆STDOUT FIO∆STDERR ◊ ⍎massert

  SECTION "Fail on non-existant file/fd"
  FD←100
  result←~↑"r" FIO∆OPEN_FILE "tests/nonexisting-file"    ◊ ⍎massert
  result←~↑FIO∆CLOSE_FD FD                               ◊ ⍎massert
  result←~↑FD FIO∆READ_FD 500                            ◊ ⍎massert
  result←~↑FIO∆READ_LINE_FD FD                           ◊ ⍎massert
  result←~↑FIO∆READ_ENTIRE_FD FD                         ◊ ⍎massert
  result←~↑FIO∆READ_ENTIRE_FILE "tests/nonexisting-file" ◊ ⍎massert
  result←~↑FD FIO∆WRITE_FD 0                             ◊ ⍎massert
  result←~↑FIO∆REMOVE "tests/nonexisting-file"           ◊ ⍎massert
  result←~↑FIO∆REMOVE_RECURSIVE "tests/nonexisting-file" ◊ ⍎massert
  result←~↑FD FIO∆PRINT_FD ""                            ◊ ⍎massert
  result←~↑FD FIO∆PRINTF_FD ""                           ◊ ⍎massert

  SECTION "FIO∆OPEN_FILE & FIO∆CLOSE_FD"
  FD←"r" FIO∆OPEN_FILE FILE ◊ result←↑FD ◊ ⍎massert ◊ FD←↑1↓FD
  result←↑FIO∆CLOSE_FD FD ◊ ⍎massert

  SECTION "FIO∆IS_FILE"
  result←FIO∆IS_FILE FILE                      ◊ ⍎massert
  result←~FIO∆IS_FILE "tests/nonexisting-file" ◊ ⍎massert
  result←~FIO∆IS_FILE "tests/"                 ◊ ⍎massert

  SECTION "FIO∆READ_FD"
  FD←"r" FIO∆OPEN_FILE FILE ◊ result←↑FD ◊ ⍎massert ◊ FD←↑1↓FD
  CONTENTS←⍬
  LREAD_LOOP:
    BUFFER←FD FIO∆READ_FD 500
    →(~↑BUFFER) ⍴ LREAD_LOOP_END
    CONTENTS←CONTENTS,↑1↓BUFFER
  LREAD_LOOP_END:
  result←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 CONTENTS ◊ ⍎massert
  result←~↑FD FIO∆READ_FD 500                     ◊ ⍎massert
  result←↑FIO∆CLOSE_FD FD                         ◊ ⍎massert

  SECTION "FIO∆READ_LINE_FD"
  FD←"r" FIO∆OPEN_FILE FILE ◊ result←↑FD ◊ ⍎massert ◊ FD←↑1↓FD
  CONTENTS←⍬
  BUFFER←FIO∆READ_LINE_FD FD ◊ result←↑BUFFER               ◊ ⍎massert
  BUFFER←↑1↓BUFFER ◊ CONTENTS←CONTENTS,⊂BUFFER
  result←(FIO∆BYTES_TO_UTF8 BUFFER)≡↑FILE_CONTENTS_LINES[1] ◊ ⍎massert
  BUFFER←FIO∆READ_LINE_FD FD ◊ result←↑BUFFER               ◊ ⍎massert
  BUFFER←↑1↓BUFFER ◊ CONTENTS←CONTENTS,⊂BUFFER
  result←(FIO∆BYTES_TO_UTF8 BUFFER)≡↑FILE_CONTENTS_LINES[2] ◊ ⍎massert
  BUFFER←FIO∆READ_LINE_FD FD ◊ result←↑BUFFER               ◊ ⍎massert
  BUFFER←↑1↓BUFFER ◊ CONTENTS←CONTENTS,⊂BUFFER
  result←(FIO∆BYTES_TO_UTF8 BUFFER)≡↑FILE_CONTENTS_LINES[3] ◊ ⍎massert
  BUFFER←FIO∆READ_LINE_FD FD ◊ result←↑BUFFER               ◊ ⍎massert
  BUFFER←↑1↓BUFFER ◊ CONTENTS←CONTENTS,⊂BUFFER
  result←(FIO∆BYTES_TO_UTF8 BUFFER)≡↑FILE_CONTENTS_LINES[4] ◊ ⍎massert
  result←FILE_CONTENTS_LINES≡FIO∆BYTES_TO_UTF8¨ CONTENTS    ◊ ⍎massert
  result←~↑FIO∆READ_LINE_FD FD                              ◊ ⍎massert
  result←↑FIO∆CLOSE_FD FD                                   ◊ ⍎massert

  SECTION "FIO∆READ_ENTIRE_FD"
  FD←"r" FIO∆OPEN_FILE FILE ◊ result←↑FD ◊ ⍎massert  ◊ FD←↑1↓FD
  CONTENTS←FIO∆READ_ENTIRE_FD FD ◊ result←↑CONTENTS   ◊ ⍎massert
  result←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 ↑1↓CONTENTS  ◊ ⍎massert
  result←~↑FIO∆READ_ENTIRE_FD FD                      ◊ ⍎massert
  result←↑FIO∆CLOSE_FD FD                             ◊ ⍎massert

  SECTION "FIO∆READ_ENTIRE_FILE"
  result←~↑FIO∆READ_ENTIRE_FILE "tests/" ◊ ⍎massert
  ⍝ ^ Fail on directory.
  CONTENTS←FIO∆READ_ENTIRE_FILE FILE ◊ ⍎massert ◊ result←↑CONTENTS ◊ ⍎massert
  result←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 ↑1↓CONTENTS ◊ ⍎massert

  SECTION "FIO∆WRITE_FD"
  FD←"w" FIO∆OPEN_FILE "tests/new-file" ◊ result←↑FD ◊ ⍎massert ◊ FD←↑1↓FD
  result←↑FD FIO∆WRITE_FD FIO∆UTF8_TO_BYTES FILE_CONTENTS ◊ ⍎massert
  result←↑FIO∆CLOSE_FD FD                                 ◊ ⍎massert
  CONTENTS←FIO∆READ_ENTIRE_FILE "tests/new-file"
  result←↑CONTENTS                                   ◊ ⍎massert
  result←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 ↑1↓CONTENTS ◊ ⍎massert
  result←↑FIO∆REMOVE "tests/new-file"                ◊ ⍎massert

  SECTION "FIO∆PRINT_FD"
  FD←"w" FIO∆OPEN_FILE "tests/new-file" ◊ result←↑FD ◊ ⍎massert ◊ FD←↑1↓FD
  result←↑FD FIO∆PRINT_FD FILE_CONTENTS  ◊ ⍎massert
  result←↑FIO∆CLOSE_FD FD                ◊ ⍎massert
  CONTENTS←FIO∆READ_ENTIRE_FILE "tests/new-file"
  result←↑CONTENTS                                   ◊ ⍎massert
  result←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 ↑1↓CONTENTS ◊ ⍎massert
  result←↑FIO∆REMOVE "tests/new-file"                ◊ ⍎massert

  SECTION "FIO∆PRINTF_FD"
  FD←"w" FIO∆OPEN_FILE "tests/new-file" ◊ result←↑FD ◊ ⍎massert ◊ FD←↑1↓FD
  BYTES_WRITTEN←FD FIO∆PRINTF_FD "%s" FILE_CONTENTS
  result←↑BYTES_WRITTEN ◊ ⍎massert ◊ BYTES_WRITTEN←↑1↓BYTES_WRITTEN
  result←(≢FILE_CONTENTS)≡BYTES_WRITTEN ◊ ⍎massert
  result←↑FIO∆CLOSE_FD FD               ◊ ⍎massert
  CONTENTS←FIO∆READ_ENTIRE_FILE "tests/new-file"
  result←↑CONTENTS                                   ◊ ⍎massert
  result←FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 ↑1↓CONTENTS ◊ ⍎massert
  result←↑FIO∆REMOVE "tests/new-file"                ◊ ⍎massert

lfail:
∇

∇TEST_PROCESS_HANDLING; result;APL_PATH;COMMAND;FD;OUTPUT
  SECTION "FIO∆ESCAPE_SHELL_ARGUMENT"
  result←"''"≡FIO∆ESCAPE_SHELL_ARGUMENT ""
  ⍎massert
  result←"'this is a test'"≡FIO∆ESCAPE_SHELL_ARGUMENT "this is a test"
  ⍎massert
  result←"'rot -F p'"≡FIO∆ESCAPE_SHELL_ARGUMENT "rot -F p"
  ⍎massert
  result←"'Today'\\''s the day'"≡FIO∆ESCAPE_SHELL_ARGUMENT "Today's the day"
  ⍎massert
  result←("'test'" "'text'" "'--option'" "'it'\\''s'")≡FIO∆ESCAPE_SHELL_ARGUMENT¨ "test" "text" "--option" "it's"
  ⍎massert

  SECTION "Fail on non-existant fd"
  FD←100
  result←~↑FIO∆PCLOSE FD ◊ ⍎massert

  SECTION "FIO∆JOIN_SHELL_ARGUMENTS"
  result←"'This is' 'a test'"≡"'This is'" FIO∆JOIN_SHELL_ARGUMENTS "'a test'"
  ⍎massert
  result←"these are some arugments"≡↑FIO∆JOIN_SHELL_ARGUMENTS/"these" "are" "some" "arugments"
  ⍎massert

  SECTION "FIO∆POPEN_READ"
  APL_PATH←↑⎕ARG
  COMMAND←APL_PATH "--script" "--LX" '⍞←"Hello World!" ◊ ⍎")OFF"'
  FD←FIO∆POPEN_READ COMMAND ◊ result←↑FD ◊ ⍎massert ◊ FD←↑1↓FD
  OUTPUT←FIO∆READ_ENTIRE_FD FD ◊ result←↑OUTPUT ◊ ⍎massert ◊ OUTPUT←↑1↓OUTPUT
  result←"Hello World!\n"≡FIO∆BYTES_TO_UTF8 OUTPUT ◊ ⍎massert
  OUTPUT←FIO∆PCLOSE FD ◊ result←↑OUTPUT ◊ ⍎massert ◊ OUTPUT←↑1↓OUTPUT
  result←0≡OUTPUT ◊ ⍎massert

lfail:
∇

∇TEST_TIME; result;S;MS;US;TIME
  SECTION "Fetch current time"
  S←FIO∆TIME_S   ◊ result←↑S  ◊ ⍎massert ◊ S←↑1↓S
  MS←FIO∆TIME_MS ◊ result←↑MS ◊ ⍎massert ◊ MS←↑1↓MS
  US←FIO∆TIME_US ◊ result←↑US ◊ ⍎massert ◊ US←↑1↓US

  SECTION "Time should increase"
  TIME←FIO∆TIME_S ◊ result←↑TIME ◊ ⍎massert ◊ TIME←↑1↓TIME
  result←S≤TIME ◊ ⍎massert
  TIME←FIO∆TIME_MS ◊ result←↑TIME ◊ ⍎massert ◊ TIME←↑1↓TIME
  result←MS≤TIME ◊ ⍎massert
  TIME←FIO∆TIME_US ◊ result←↑TIME ◊ ⍎massert ◊ TIME←↑1↓TIME
  result←US≤TIME ◊ ⍎massert

lfail:
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Test Runner                                                                  ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⊣ ⍎")COPY ./fio.apl"

∇MAIN
  RUN "TEST_UTF8_BYTES_CONVERSION"
  RUN "TEST_MISC"
  RUN "TEST_SPLITTING_VECTORS"
  RUN "TEST_PATH_HANDLING"
  RUN "TEST_DIRECTORY_HANDLING"
  RUN "TEST_FILE_HANDLING"
  RUN "TEST_PROCESS_HANDLING"
  RUN "TEST_TIME"
  ⍞←"\n" ◊ REPORT

  →(0≡≢failed_tests) ⍴ lsuccess
    ⍎")OFF 1"
  lsuccess:
∇
MAIN

)OFF
