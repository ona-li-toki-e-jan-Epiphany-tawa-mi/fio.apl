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
    ⍎")OFF"
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
∇REPORT; TESTS_PASSED
  TESTS_PASSED←TEST_COUNT-≢FAILED_TESTS
  ⍞←TESTS_PASSED ◊ ⍞←"/" ◊ ⍞←TEST_COUNT ◊ ⍞←" test(s) passed - "
  →(0≢≢FAILED_TESTS) ⍴ LTESTS_FAILED
    ⍞←"OK\n" ◊ →LTESTS_PASSED
  LTESTS_FAILED:
    ⍞←"FAIL\n"
    ⍞←"\nPlease review the following failed tests:\n"
    ⊣ { ⊣ ⍞←" - ",⍵,"\n" }¨FAILED_TESTS
  LTESTS_PASSED:
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Tests                                                                        ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

EXISTING_FILE←"tests/existing-file"
EXISTING_FILE_CONTENTS←"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
EXISTING_FILE_CONTENTS_LINES←"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat." "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

∇TEST_UTF8_BYTES_CONVERSION; RESULT;STRING;BYTES;ASSERT_UTF8_BYTES_CONVERSION
  ASSERT_UTF8_BYTES_CONVERSION←"RESULT←BYTES≡FIO∆UTF8_TO_BYTES STRING ◊ ⍎ASSERT_R ◊ RESULT←STRING≡FIO∆BYTES_TO_UTF8 BYTES ◊ ⍎ASSERT_R"

  SECTION "1"
  STRING←"This is a test"
  BYTES←84 104 105 115 32 105 115 32 97 32 116 101 115 116
  ⍎ASSERT_UTF8_BYTES_CONVERSION

  SECTION "2"
  STRING←"Have you tried C-\\ APL-Z RET?"
  BYTES←72 97 118 101 32 121 111 117 32 116 114 105 101 100 32 67 45 92 32 65 80 76 45 90 32 82 69 84 63
  ⍎ASSERT_UTF8_BYTES_CONVERSION

  SECTION "3"
  STRING←"Вы что, яйцо?"
  BYTES←208 146 209 139 32 209 135 209 130 208 190 44 32 209 143 208 185 209 134 208 190 63
  ⍎ASSERT_UTF8_BYTES_CONVERSION

LFAIL:
∇

∇TEST_ASSUMPTIONS; RESULT
  SECTION "Standard file descriptors"
  RESULT←0≡FIO∆STDIN  ◊ ⍎ASSERT_R
  RESULT←1≡FIO∆STDOUT ◊ ⍎ASSERT_R
  RESULT←2≡FIO∆STDERR ◊ ⍎ASSERT_R

  SECTION "Empty ERRNO"
  RESULT←0≡FIO∆ERRNO                                          ◊ ⍎ASSERT_R
  RESULT←(FIO∆STRERROR FIO∆ERRNO)≡FIO∆UTF8_TO_BYTES "Success" ◊ ⍎ASSERT_R

  SECTION "Standard open file descriptors"
  RESULT←3≡≢FIO∆LIST_FDS                                ◊ ⍎ASSERT_R
  RESULT←∧/FIO∆LIST_FDS∊FIO∆STDIN FIO∆STDOUT FIO∆STDERR ◊ ⍎ASSERT_R

LFAIL:
∇

∇TEST_SPLITTING_VECTORS; VECTOR;RESULT
  SECTION "Number vector"
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

  SECTION "Character vector"
  RESULT←EXISTING_FILE_CONTENTS_LINES≡"\n" FIO∆SPLIT EXISTING_FILE_CONTENTS
  ⍎ASSERT_R
  RESULT←EXISTING_FILE_CONTENTS_LINES≡"\n" FIO∆SPLIT_CLEAN EXISTING_FILE_CONTENTS
  ⍎ASSERT_R

LFAIL:
∇

∇TEST_FILE_HANDLING; RESULT;FD;CONTENTS;BUFFER;ASSERT_FOPEN;ASSERT_READ;ASSERT_FCLOSE;_ASSERT_FGETS
  SECTION "Fail on non-existant file"
  FD←"r" FIO∆FOPEN "tests/nonexisting-file"
  RESULT←1>FD ◊ ⍎ASSERT_R

  ⍝ Should open fd.
  ASSERT_FOPEN←{'FD←"',⍺,'" FIO∆FOPEN "',⍵,'" ◊ RESULT←1≤FD ◊ ⍎ASSERT_R'}
  ⍝ Should read exact file contents without error.
  ASSERT_READ←"RESULT←0≡FIO∆FERROR FD ◊ ⍎ASSERT_R ◊ RESULT←0≢FIO∆FEOF FD ◊ ⍎ASSERT_R ◊ RESULT←EXISTING_FILE_CONTENTS≡FIO∆BYTES_TO_UTF8 CONTENTS ◊ ⍎ASSERT_R"
  ⍝ Should close fd.
  ASSERT_FCLOSE←"RESULT←0≡FIO∆FCLOSE FD ◊ ⍎ASSERT_R"

  SECTION "FIO∆FREAD"
  ⍎"r" ASSERT_FOPEN EXISTING_FILE
  CONTENTS←⍬
  LFREAD_LOOP:
    BUFFER←500 FIO∆FREAD FD
    →(0≡BUFFER) ⍴ LEND_FREAD_LOOP
    CONTENTS←CONTENTS,BUFFER ◊ →LFREAD_LOOP
  LEND_FREAD_LOOP:
  RESULT←0≡500 FIO∆FREAD FD ◊ ⍎ASSERT_R
  ⍎ASSERT_READ ◊ ⍎ASSERT_FCLOSE

  SECTION "FIO∆FGETS"
  ⍎"r" ASSERT_FOPEN EXISTING_FILE
  ⍝ Should read file line-by-line, preserving newlines.
  CONTENTS←⍬
  ASSERT_FGETS←{"BUFFER←500 FIO∆FGETS FD ◊ CONTENTS←CONTENTS,BUFFER ◊ RESULT←(FIO∆BYTES_TO_UTF8 BUFFER)≡",(↑('"\n",⍨' "")[1+⍺]),"↑EXISTING_FILE_CONTENTS_LINES[",⍵,"] ◊ ⍎ASSERT_R"}
  ⍎0 ASSERT_FGETS "1"
  ⍎0 ASSERT_FGETS "2"
  ⍎0 ASSERT_FGETS "3"
  ⍎1 ASSERT_FGETS "4"
  RESULT←0≡500 FIO∆FGETS FD ◊ ⍎ASSERT_R
  ⍎ASSERT_READ ◊ ⍎ASSERT_FCLOSE

  SECTION "FIO∆READ_ENTIRE_FD"
  ⍎"r" ASSERT_FOPEN EXISTING_FILE
  RESULT←1≤FD ◊ ⍎ASSERT_R
  CONTENTS←FIO∆READ_ENTIRE_FD FD
  RESULT←0≡FIO∆READ_ENTIRE_FD FD ◊ ⍎ASSERT_R
  ⍎ASSERT_READ ◊ ⍎ASSERT_FCLOSE

LFAIL:
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Test Runner                                                                  ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

)COPY ./fio.apl
⍞←" ^ Output of )COPY. Unimportant, please ignore\n\n"

∇MAIN
  RUN "TEST_ASSUMPTIONS"
  RUN "TEST_SPLITTING_VECTORS"
  RUN "TEST_UTF8_BYTES_CONVERSION"
  RUN "TEST_FILE_HANDLING"
  ⍞←"\n" ◊ REPORT
∇
MAIN

)OFF
