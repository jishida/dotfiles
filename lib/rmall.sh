use quote

rmall() {
  (
    QTARGET="$(quote "$1")"
    COMMAND=''
    info "removing $QTARGET" "$2" "$3"
    if [ -L "$1" ]; then
      COMMAND='unlink'
    else
      if [ -e "$1" ]; then
        if [ -d "$1" ]; then
          COMMAND='rm -rf'
        else
          COMMAND='rm -vf'
        fi
      fi
    fi
    if [ -n "$COMMAND" ]; then
      OUTPUT="$($COMMAND "$1" 2>&1)"
      RC=$?
      test -n "$OUTPUT" && debug "$OUTPUT" rmall "rm $OPT $QTARGET"
      test $RC -ne 0 && \
        fatal "failed to remove $QTARGET" "$2" "$3"
    else
      debug "$QTARGET doesn't exist"
    fi
    return 0
  )
}
