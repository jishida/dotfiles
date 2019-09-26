#!/bin/sh

eval "$(sh "$(cd "$(dirname "$0")"&&pwd)/../libexec/modulize.sh")"

use escape
use testing
use print
use debug
use hex

test_mod escape_test

test_unit escape_lf

_assert_lf() {
    SECTION='escape_lf/unescape_lf'

    UNESCAPED="$1"
    ESCAPED="$2"
    ESCAPED_ACTUAL="$(escape_lf "$UNESCAPED";print _)"
    ESCAPED_ACTUAL="${ESCAPED_ACTUAL%_}"
    UNESCAPED_ACTUAL="$(unescape_lf "$ESCAPED";print _)"
    UNESCAPED_ACTUAL="${UNESCAPED_ACTUAL%_}"

   (
      scope escape_test "$SECTION"

      debug_var ESCAPED 7
      debug_var ESCAPED_ACTUAL
      debug_var UNESCAPED 7
      debug_var UNESCAPED_ACTUAL

      debug_hex ESCAPED 7
      debug_hex ESCAPED_ACTUAL
      debug_hex UNESCAPED 7
      debug_hex UNESCAPED_ACTUAL
    )

    assert 'test "$ESCAPED" = "$ESCAPED_ACTUAL"' "$SECTION"
    assert 'test "$UNESCAPED" = "$UNESCAPED_ACTUAL"' "$SECTION"
}

_assert_lfp() {
    SECTION='escape_lfp/unescape_lfp'

    UNESCAPED="$1"
    ESCAPED="$2"
    ESCAPED_ACTUAL="$(print "$UNESCAPED" | escape_lfp;print _)"
    ESCAPED_ACTUAL="${ESCAPED_ACTUAL%_}"
    UNESCAPED_ACTUAL="$(print "$ESCAPED" | unescape_lfp;print _)"
    UNESCAPED_ACTUAL="${UNESCAPED_ACTUAL%_}"

    (
      scope escape_test "$SECTION"

      debug_var ESCAPED 7
      debug_var ESCAPED_ACTUAL
      debug_var UNESCAPED 7
      debug_var UNESCAPED_ACTUAL

      debug_hex ESCAPED 7
      debug_hex ESCAPED_ACTUAL
      debug_hex UNESCAPED 7
      debug_hex UNESCAPED_ACTUAL
    )

    assert 'test "$ESCAPED" = "$ESCAPED_ACTUAL"' "$SECTION"
    assert 'test "$UNESCAPED" = "$UNESCAPED_ACTUAL"' "$SECTION"
}

assert_escape_lf() {
  _assert_lf "$1" "$2"
  _assert_lfp "$1" "$2"
}

assert_escape_lf '
' '\n'
assert_escape_lf '\' '\\'
assert_escape_lf '\
' '\\\n'
assert_escape_lf '_' '_'
assert_escape_lf '__' '__'

assert_escape_lf '\
\\
\\\
\n
\\n
\\\n
a
\a
\\a
\\\a
b\
b\\
b\\\

' '\\\n\\\\\n\\\\\\\n\\n\n\\\\n\n\\\\\\n\na\n\\a\n\\\\a\n\\\\\\a\nb\\\nb\\\\\nb\\\\\\\n\n'

test_exit
