use quote

mklink() {
  (
    QTARGET="$(quote "$1")"
    if [ ! -e "$1" ]; then
      fatal "target $QTARGET not found" "$3" "$4"
    fi
    QLINK="$(quote "$2")"
    if [ -e "$2" ]; then
      fatal "$QLINK already exists" "$3" "$4"
    fi
    DSCR="($QTARGET -> $QLINK)"
    info "creating symbolic link $DSCR" "$3" "$4"
    OUTPUT="$(ln -sv "$1" "$2" 2>&1)"
    RC=$?
    test -n "$OUTPUT" && debug "$OUTPUT" mklink "ln -sv $QTARGET $QLINK"
    test $RC -ne 0 && \
      fatal "failed to create symbolic link $DSCR" "$3" "$4"
    return 0
  )
}
