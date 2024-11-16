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
ASSERTION_NUMBER←0
TEST_FAILED←0
FAILED_TESTS←⍬

⍝ TODO document.
∇RUN TEST; RESULT
  TEST_COUNT←1+TEST_COUNT

  TEST_FAILED←0
  ASSERTION_NUMBER←0
  ⍞←"Runnning test '" ◊ ⍞←TEST ◊ ⍞←"'... "
  ⍎TEST

  →TEST_FAILED ⍴ LFAILED
    ⍞←"OK\n" ◊ →LNOT_FAILED
  LFAILED:
    ⍞←"FAIL\n"
    FAILED_TESTS←FAILED_TESTS,⊂TEST," on assertion",ASSERTION_NUMBER
  LNOT_FAILED:
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

EXISTING_FILE_CONTENTS←"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
EXISTING_FILE_CONTENTS_LINES←"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat." "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

∇TEST_ASSUMPTIONS; RESULT
  RESULT←0≡FIO∆STDIN  ◊ ⍎ASSERT_R
  RESULT←1≡FIO∆STDOUT ◊ ⍎ASSERT_R
  RESULT←2≡FIO∆STDERR ◊ ⍎ASSERT_R

  ⍝ Should be nothing in ERRNO.
  RESULT←0≡FIO∆ERRNO                      ◊ ⍎ASSERT_R
  RESULT←"Success"≡FIO∆STRERROR FIO∆ERRNO ◊ ⍎ASSERT_R

  ⍝ At the time of calling, these should be the only open file descriptors.
  RESULT←3≡≢FIO∆LIST_FDS                                ◊ ⍎ASSERT_R
  RESULT←∧/FIO∆LIST_FDS∊FIO∆STDIN FIO∆STDOUT FIO∆STDERR ◊ ⍎ASSERT_R

LFAIL:
∇

∇TEST_SPLITTING_VECTORS; VECTOR;RESULT
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

  RESULT←EXISTING_FILE_CONTENTS_LINES≡"\n" FIO∆SPLIT EXISTING_FILE_CONTENTS
  ⍎ASSERT_R
  RESULT←EXISTING_FILE_CONTENTS_LINES≡"\n" FIO∆SPLIT_CLEAN EXISTING_FILE_CONTENTS
  ⍎ASSERT_R

LFAIL:
∇

LFAIL:
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Test runner                                                                  ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

)COPY ./fio.apl
⍞←" ^ Output of )COPY. Unimportant, please ignore\n\n"

∇MAIN
  RUN "TEST_ASSUMPTIONS"
  RUN "TEST_SPLITTING_VECTORS"
  ⍞←"\n" ◊ REPORT
∇
MAIN

)OFF
