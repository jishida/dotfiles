#!/bin/sh

eval "$(sh "$(cd "$(dirname "$0")"&&pwd)/../libexec/modulize.sh")"

TEST_NAME=logging_test

LOG_LEVEL=0

debug 'should print debug message' logging_test
info 'should print info message' logging_test
warn 'should print warn message' logging_test
error 'should print error message' logging_test
fatal 'should print fatal message' logging_test

echo 'must not print'
