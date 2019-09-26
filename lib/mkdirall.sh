use quote

__mkdirall_impl() {
  set -- "$1" "$(dirname "$1")"
  case "$2" in
    '.'|'/') return 0;;
  esac
  if [ ! -d "$2" ]; then
    __mkdirall_impl "$PARENT" || return 1
  fi
  (
    OUTPUT="$(mkdir -v "$1" 2>&1)"
    RC=$?
    test -n "$OUTPUT" && debug "$OUTPUT" mkdirall "mkdir -v $(quote "$1")"
    return $RC
  )
}

mkdirall() {
  (
    QTARGET="$(quote "$1")"
    if [ -e "$1" ]; then
      if [ -d "$1" ]; then
        debug "$QTARGET already exists" "$2" "$3"
      else
        fatal "$QTARGET file exists" "$2" "$3"
      fi
    else
      info "creating $QTARGET" "$2" "$3"
      __mkdirall_impl "$1" || \
        fatal "failed to create $QTARGET" "$2" "$3"
    fi
  )
}
