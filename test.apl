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

∇TEST_UTF8_BYTES_CONVERSION; result;string;bytes
  SECTION "1"
  string←"This is a test"
  bytes←84 104 105 115 32 105 115 32 97 32 116 101 115 116
  result←bytes≡FIO∆UTF8_TO_BYTES string ◊ ⍎massert
  result←string≡FIO∆BYTES_TO_UTF8 bytes ◊ ⍎massert

  SECTION "2"
  string←"Have you tried C-\\ APL-Z RET?"
  bytes←72 97 118 101 32 121 111 117 32 116 114 105 101 100 32 67 45 92 32 65 80 76 45 90 32 82 69 84 63
  result←bytes≡FIO∆UTF8_TO_BYTES string ◊ ⍎massert
  result←string≡FIO∆BYTES_TO_UTF8 bytes ◊ ⍎massert

  SECTION "3"
  string←"Вы что, яйцо?"
  bytes←208 146 209 139 32 209 135 209 130 208 190 44 32 209 143 208 185 209 134 208 190 63
  result←bytes≡FIO∆UTF8_TO_BYTES string ◊ ⍎massert
  result←string≡FIO∆BYTES_TO_UTF8 bytes ◊ ⍎massert

lfail:
∇

∇TEST_MISC; result
  SECTION "Assumptions"
  result←0≡FIO∆ERRNO                      ◊ ⍎massert
  result←"Success"≡FIO∆STRERROR FIO∆ERRNO ◊ ⍎massert

lfail:
∇

∇TEST_SPLITTING_VECTORS; vector;result
  SECTION "Splitting number vector"
  vector←1 1 2 2 3 3 4 4 5 5
  result←(1 FIO∆SPLIT vector)≡⍬ (2 2 3 3 4 4 5 5)        ◊ ⍎massert
  result←(2 FIO∆SPLIT vector)≡(1 1) ⍬ (3 3 4 4 5 5)      ◊ ⍎massert
  result←(3 FIO∆SPLIT vector)≡(1 1 2 2) ⍬ (4 4 5 5)      ◊ ⍎massert
  result←(4 FIO∆SPLIT vector)≡(1 1 2 2 3 3) ⍬ (5 5)      ◊ ⍎massert
  result←(5 FIO∆SPLIT vector)≡(1 1 2 2 3 3 4 4) ⍬ ⍬      ◊ ⍎massert
  result←(1 FIO∆SPLIT_CLEAN vector)≡⍬,⊂(2 2 3 3 4 4 5 5) ◊ ⍎massert
  result←(2 FIO∆SPLIT_CLEAN vector)≡(1 1) (3 3 4 4 5 5)  ◊ ⍎massert
  result←(3 FIO∆SPLIT_CLEAN vector)≡(1 1 2 2) (4 4 5 5)  ◊ ⍎massert
  result←(4 FIO∆SPLIT_CLEAN vector)≡(1 1 2 2 3 3) (5 5)  ◊ ⍎massert
  result←(5 FIO∆SPLIT_CLEAN vector)≡⍬,⊂1 1 2 2 3 3 4 4   ◊ ⍎massert

  SECTION "Splitting strings"
  vector←"This is\na\n\ntest"
  result←"This is" "a" (0⍴'') "test"≡"\n" FIO∆SPLIT vector ◊ ⍎massert
  result←"This is" "a" "test"≡"\n" FIO∆SPLIT_CLEAN vector  ◊ ⍎massert
  vector←"/bin:/usr/bin:/usr/local/bin"
  result←"/bin" "/usr/bin" "/usr/local/bin"≡":" FIO∆SPLIT vector
  ⍎massert
  result←"/bin" "/usr/bin" "/usr/local/bin"≡":" FIO∆SPLIT_CLEAN vector
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
  result←"empty"≡"" FIO∆JOIN_PATH "empty"         ◊ ⍎massert
  result←"directory"≡"directory" FIO∆JOIN_PATH "" ◊ ⍎massert

lfail:
∇

∇TEST_DIRECTORY_HANDLING; result;contents;fd
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
  contents←FIO∆LIST_DIRECTORY "tests/" ◊ result←↑contents   ◊ ⍎massert
  contents←↑1↓contents ◊ result←contents≡⍬,⊂"existing-file" ◊ ⍎massert

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
  fd←"w" FIO∆OPEN_FILE "tests/this/is/a/test/file"
  result←↑fd ◊ ⍎massert ◊ fd←↑1↓fd
  result←↑fd FIO∆WRITE_FD FIO∆UTF8_TO_BYTES "Hello, World!" ◊ ⍎massert
  result←↑FIO∆CLOSE_FD fd                                   ◊ ⍎massert
  result←↑FIO∆REMOVE_RECURSIVE "tests/this"                 ◊ ⍎massert
  result←~↑FIO∆LIST_DIRECTORY "tests/this/"                 ◊ ⍎massert

lfail:
∇

∇TEST_FILE_HANDLING; file;file_contents;file_contents_lines;result;fd;contents;buffer;bytes_written
  file←"tests/existing-file"
  file_contents←"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  file_contents_lines←"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat." "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

  SECTION "Assumptions"
  result←0≡FIO∆stdin                                    ◊ ⍎massert
  result←1≡FIO∆stdout                                   ◊ ⍎massert
  result←2≡FIO∆stderr                                   ◊ ⍎massert
  result←3≡≢FIO∆LIST_FDS                                ◊ ⍎massert
  result←∧/FIO∆LIST_FDS∊FIO∆stdin FIO∆stdout FIO∆stderr ◊ ⍎massert

  SECTION "Fail on non-existant file/fd"
  fd←100
  result←~↑"r" FIO∆OPEN_FILE "tests/nonexisting-file"    ◊ ⍎massert
  result←~↑FIO∆CLOSE_FD fd                               ◊ ⍎massert
  result←~↑fd FIO∆READ_FD 500                            ◊ ⍎massert
  result←~↑FIO∆READ_LINE_FD fd                           ◊ ⍎massert
  result←~↑FIO∆READ_ENTIRE_FD fd                         ◊ ⍎massert
  result←~↑FIO∆READ_ENTIRE_FILE "tests/nonexisting-file" ◊ ⍎massert
  result←~↑fd FIO∆WRITE_FD 0                             ◊ ⍎massert
  result←~↑FIO∆REMOVE "tests/nonexisting-file"           ◊ ⍎massert
  result←~↑FIO∆REMOVE_RECURSIVE "tests/nonexisting-file" ◊ ⍎massert
  result←~↑fd FIO∆PRINT_FD ""                            ◊ ⍎massert
  result←~↑fd FIO∆PRINTF_FD ""                           ◊ ⍎massert

  SECTION "FIO∆OPEN_FILE & FIO∆CLOSE_FD"
  fd←"r" FIO∆OPEN_FILE file ◊ result←↑fd ◊ ⍎massert ◊ fd←↑1↓fd
  result←↑FIO∆CLOSE_FD fd ◊ ⍎massert

  SECTION "FIO∆IS_FILE"
  result←FIO∆IS_FILE file                      ◊ ⍎massert
  result←~FIO∆IS_FILE "tests/nonexisting-file" ◊ ⍎massert
  result←~FIO∆IS_FILE "tests/"                 ◊ ⍎massert

  SECTION "FIO∆READ_FD"
  fd←"r" FIO∆OPEN_FILE file ◊ result←↑fd ◊ ⍎massert ◊ fd←↑1↓fd
  contents←⍬
  LREAD_LOOP:
    buffer←fd FIO∆READ_FD 500
    →(~↑buffer) ⍴ LREAD_LOOP_END
    contents←contents,↑1↓buffer
  LREAD_LOOP_END:
  result←file_contents≡FIO∆BYTES_TO_UTF8 contents ◊ ⍎massert
  result←~↑fd FIO∆READ_FD 500                     ◊ ⍎massert
  result←↑FIO∆CLOSE_FD fd                         ◊ ⍎massert

  SECTION "FIO∆READ_LINE_FD"
  fd←"r" FIO∆OPEN_FILE file ◊ result←↑fd ◊ ⍎massert ◊ fd←↑1↓fd
  contents←⍬
  buffer←FIO∆READ_LINE_FD fd ◊ result←↑buffer               ◊ ⍎massert
  buffer←↑1↓buffer ◊ contents←contents,⊂buffer
  result←(FIO∆BYTES_TO_UTF8 buffer)≡↑file_contents_lines[1] ◊ ⍎massert
  buffer←FIO∆READ_LINE_FD fd ◊ result←↑buffer               ◊ ⍎massert
  buffer←↑1↓buffer ◊ contents←contents,⊂buffer
  result←(FIO∆BYTES_TO_UTF8 buffer)≡↑file_contents_lines[2] ◊ ⍎massert
  buffer←FIO∆READ_LINE_FD fd ◊ result←↑buffer               ◊ ⍎massert
  buffer←↑1↓buffer ◊ contents←contents,⊂buffer
  result←(FIO∆BYTES_TO_UTF8 buffer)≡↑file_contents_lines[3] ◊ ⍎massert
  buffer←FIO∆READ_LINE_FD fd ◊ result←↑buffer               ◊ ⍎massert
  buffer←↑1↓buffer ◊ contents←contents,⊂buffer
  result←(FIO∆BYTES_TO_UTF8 buffer)≡↑file_contents_lines[4] ◊ ⍎massert
  result←file_contents_lines≡FIO∆BYTES_TO_UTF8¨ contents    ◊ ⍎massert
  result←~↑FIO∆READ_LINE_FD fd                              ◊ ⍎massert
  result←↑FIO∆CLOSE_FD fd                                   ◊ ⍎massert

  SECTION "FIO∆READ_ENTIRE_FD"
  fd←"r" FIO∆OPEN_FILE file ◊ result←↑fd ◊ ⍎massert  ◊ fd←↑1↓fd
  contents←FIO∆READ_ENTIRE_FD fd ◊ result←↑contents   ◊ ⍎massert
  result←file_contents≡FIO∆BYTES_TO_UTF8 ↑1↓contents  ◊ ⍎massert
  result←~↑FIO∆READ_ENTIRE_FD fd                      ◊ ⍎massert
  result←↑FIO∆CLOSE_FD fd                             ◊ ⍎massert

  SECTION "FIO∆READ_ENTIRE_FILE"
  result←~↑FIO∆READ_ENTIRE_FILE "tests/" ◊ ⍎massert
  ⍝ ^ Fail on directory.
  contents←FIO∆READ_ENTIRE_FILE file ◊ ⍎massert ◊ result←↑contents ◊ ⍎massert
  result←file_contents≡FIO∆BYTES_TO_UTF8 ↑1↓contents ◊ ⍎massert

  SECTION "FIO∆WRITE_FD"
  fd←"w" FIO∆OPEN_FILE "tests/new-file" ◊ result←↑fd ◊ ⍎massert ◊ fd←↑1↓fd
  result←↑fd FIO∆WRITE_FD FIO∆UTF8_TO_BYTES file_contents ◊ ⍎massert
  result←↑FIO∆CLOSE_FD fd                                 ◊ ⍎massert
  contents←FIO∆READ_ENTIRE_FILE "tests/new-file"
  result←↑contents                                   ◊ ⍎massert
  result←file_contents≡FIO∆BYTES_TO_UTF8 ↑1↓contents ◊ ⍎massert
  result←↑FIO∆REMOVE "tests/new-file"                ◊ ⍎massert

  SECTION "FIO∆PRINT_FD"
  fd←"w" FIO∆OPEN_FILE "tests/new-file" ◊ result←↑fd ◊ ⍎massert ◊ fd←↑1↓fd
  result←↑fd FIO∆PRINT_FD file_contents  ◊ ⍎massert
  result←↑FIO∆CLOSE_FD fd                ◊ ⍎massert
  contents←FIO∆READ_ENTIRE_FILE "tests/new-file"
  result←↑contents                                   ◊ ⍎massert
  result←file_contents≡FIO∆BYTES_TO_UTF8 ↑1↓contents ◊ ⍎massert
  result←↑FIO∆REMOVE "tests/new-file"                ◊ ⍎massert

  SECTION "FIO∆PRINTF_FD"
  fd←"w" FIO∆OPEN_FILE "tests/new-file" ◊ result←↑fd ◊ ⍎massert ◊ fd←↑1↓fd
  bytes_written←fd FIO∆PRINTF_FD "%s" file_contents
  result←↑bytes_written ◊ ⍎massert ◊ bytes_written←↑1↓bytes_written
  result←(≢file_contents)≡bytes_written ◊ ⍎massert
  result←↑FIO∆CLOSE_FD fd               ◊ ⍎massert
  contents←FIO∆READ_ENTIRE_FILE "tests/new-file"
  result←↑contents                                   ◊ ⍎massert
  result←file_contents≡FIO∆BYTES_TO_UTF8 ↑1↓contents ◊ ⍎massert
  result←↑FIO∆REMOVE "tests/new-file"                ◊ ⍎massert

lfail:
∇

∇TEST_PROCESS_HANDLING; result;apl_path;command;fd;output
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
  fd←100
  result←~↑FIO∆PCLOSE fd ◊ ⍎massert

  SECTION "FIO∆JOIN_SHELL_ARGUMENTS"
  result←"'This is' 'a test'"≡"'This is'" FIO∆JOIN_SHELL_ARGUMENTS "'a test'"
  ⍎massert
  result←"these are some arugments"≡↑FIO∆JOIN_SHELL_ARGUMENTS/"these" "are" "some" "arugments"
  ⍎massert

  SECTION "FIO∆POPEN_READ"
  apl_path←↑⎕ARG
  command←apl_path "--script" "--LX" '⍞←"Hello World!" ◊ ⍎")OFF"'
  fd←FIO∆POPEN_READ command ◊ result←↑fd ◊ ⍎massert ◊ fd←↑1↓fd
  output←FIO∆READ_ENTIRE_FD fd ◊ result←↑output ◊ ⍎massert ◊ output←↑1↓output
  result←"Hello World!\n"≡FIO∆BYTES_TO_UTF8 output ◊ ⍎massert
  output←FIO∆PCLOSE fd ◊ result←↑output ◊ ⍎massert ◊ output←↑1↓output
  result←0≡output ◊ ⍎massert

lfail:
∇

∇TEST_TIME; result;s;ms;us;time
  SECTION "Fetch current time"
  s←FIO∆TIME_S   ◊ result←↑s  ◊ ⍎massert ◊ s←↑1↓s
  ms←FIO∆TIME_MS ◊ result←↑ms ◊ ⍎massert ◊ ms←↑1↓ms
  us←FIO∆TIME_US ◊ result←↑us ◊ ⍎massert ◊ us←↑1↓us

  SECTION "Time should increase"
  time←FIO∆TIME_S ◊ result←↑time ◊ ⍎massert ◊ time←↑1↓time
  result←s≤time ◊ ⍎massert
  time←FIO∆TIME_MS ◊ result←↑time ◊ ⍎massert ◊ time←↑1↓time
  result←ms≤time ◊ ⍎massert
  time←FIO∆TIME_US ◊ result←↑time ◊ ⍎massert ◊ time←↑1↓time
  result←us≤time ◊ ⍎massert

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
