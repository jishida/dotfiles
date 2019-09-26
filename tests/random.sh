#!/bin/sh

eval "$(sh "$(cd "$(dirname "$0")"&&pwd)/../libexec/modulize.sh")"

use testing
use random

test_mod random_test

test_unit 'no args random_hex should returns 128bit hex'
for i in $(seq 1 50); do
  assertp<<__TEST__
random_hex | grep -e '^[0-9a-f]\{32\}$'
__TEST__
done

test_unit 'random_hex should returns any bytes hex'
for i in $(seq 1 55); do
  assertp<<__TEST__
random_hex $i | grep -e '^[0-9a-f]\{$(expr $i '*' 2)\}$'
__TEST__
done

test_exit
