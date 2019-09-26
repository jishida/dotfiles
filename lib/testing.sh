use escape

__MOD_TESTING_TEXT_SUCCESS="$(printf '\e[92m%s\e[m' '[success]')"
__MOD_TESTING_TEXT_FAILURE="$(printf '\e[91m%s\e[m' '[failure]')"

_test_now() {
  date -u +%s.%N
}

_test_clear() {
  __MOD_TESTING_UNIT=''
  if [ -n "${__MOD_TESTING_UNIT+x}" ]; then
    unset -v __MOD_TESTING_UNIT
  fi
  __MOD_TESTING_UNIT_START=''
  __MOD_TESTING_UNIT_FAILURE=0
}

test_mod() {
  __MOD_TESTING_MOD="$1"
  _test_clear
}

test_unit() {
  test_exit
  __MOD_TESTING_UNIT="$1"
  __MOD_TESTING_UNIT_START="$(_test_now)"
}

test_exit() {
  (
    NOW="$(_test_now)"
    if [ -n "${__MOD_TESTING_UNIT+x}" ]; then
      TIME="$(
        printf '%s %s' "$NOW" "$__MOD_TESTING_UNIT_START" | \
          awk '{printf "%.3f",$1-$2}'
      )"
      if [ "$__MOD_TESTING_UNIT_FAILURE" -eq 0 ]; then
        infop "$__MOD_TESTING_MOD" << __MOD_TESTING_EXIT_SUCCESS__
$__MOD_TESTING_TEXT_SUCCESS $__MOD_TESTING_UNIT - ${TIME}s
__MOD_TESTING_EXIT_SUCCESS__
      else
        errorp "$__MOD_TESTING_MOD" << __MOD_TESTING_EXIT_FAILURE__
$__MOD_TESTING_TEXT_FAILURE $__MOD_TESTING_UNIT - ${TIME}s
__MOD_TESTING_EXIT_FAILURE__
      fi
    fi
  )
  _test_clear
}

assert() {
  set -- "$1" "$(
    (
      (
        STDOUT="$(eval "$1")"
        printf '0%s\n' $? >&3
        printf '1%s' "$STDOUT" | escape_lf >&3
        printf '\n' >&3
      ) 2>&1 | printf '2%s' "$(cat -)" | escape_lf >&3
    ) 3>&1
  )" "$2"
  set -- "$1" \
    "$(echo "$2"|awk -v'ORS=' '/^0/{print substr($0,2)}')" \
    "$(echo "$2"|awk -v'ORS=' '/^1/{print substr($0,2)}')" \
    "$(echo "$2"|awk -v'ORS=' '/^2/{print substr($0,2)}')" \
    "$3"

  if [ $2 -eq 0 ]; then
    debugp "$__MOD_TESTING_MOD" "$5" << __MOD_TESTING_ASSERT_SUCCESS__
assertion success: $__MOD_TESTING_UNIT
>>> expr
$1
<<<
__MOD_TESTING_ASSERT_SUCCESS__
  else
    __MOD_TESTING_UNIT_FAILURE=1
    errorp "$__MOD_TESTING_MOD" "$5" << __MOD_TESTING_ASSERT_FAILURE__
assertion failure: $__MOD_TESTING_UNIT
>>> expr
$1
<<<
__MOD_TESTING_ASSERT_FAILURE__
  fi

  if [ -n "$3" ]; then
    debugp "$__MOD_TESTING_MOD" "$5" << __MOD_TESTING_ASSERT_OUTPUT__
assertion stdout: $__MOD_TESTING_UNIT
>>> stdout
$(unescape_lf "$3")
<<<
__MOD_TESTING_ASSERT_OUTPUT__
  fi

  if [ -n "$4" ]; then
    warnp "$__MOD_TESTING_MOD" "$5" << __MOD_TESTING_ASSERT_ERROR__
assertion stderr: $__MOD_TESTING_UNIT
>>> stderr
$(unescape_lf "$4")
<<<
__MOD_TESTING_ASSERT_ERROR__
  fi

  return $2
}

assertp() {
  assert "$(cat -)" "$1"
}
