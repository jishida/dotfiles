check() {
  debug "command check - '$1'" check check
  if command -v "$1" >/dev/null 2>&1; then
    debug "command '$1' exists" check check
    return 0
  else
    debug "command '$1' not found" check check
    return 1
  fi
}
