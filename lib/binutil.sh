bin_init() {
  BIN_NAME="$1"
  scope "$1" main
  info "$1 starts processing"
}

bin_exit() {
  info "$BIN_NAME has completed successfully"
  exit 0
}
