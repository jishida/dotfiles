#!/bin/sh

DQ='"'
printf '%s\n\n' "ROOT='$(cd "$(dirname "$0")/.."&&(pwd|sed -e "s/'/'$DQ'$DQ'/g"))'"

cat -<<'__MODULIZE__'
__MODULIZE_LOGGING_TEXT_DEBUG="$(printf '\e[90m%s\e[m' '[DEBUG]')"
__MODULIZE_LOGGING_TEXT_INFO="$(printf '\e[94m%s\e[m' '[INFO]')"
__MODULIZE_LOGGING_TEXT_WARN="$(printf '\e[93m%s\e[m' '[WARN]')"
__MODULIZE_LOGGING_TEXT_ERROR="$(printf '\e[91m%s\e[m' '[ERROR]')"
__MODULIZE_LOGGING_TEXT_FATAL="$(printf '\e[35m%s\e[m' '[FATAL]')"

__MODULIZE_TEXTINFO="$(command -v info)"

texinfo() {
  command "$__MODULIZE_TEXTINFO"
}

LOG_DEBUG=0
LOG_INFO=1
LOG_WARN=2
LOG_ERROR=3
LOG_FATAL=4

case "$LOG_LEVEL" in
  [Dd][Ee][Bb][Uu][Gg]) LOG_LEVEL=$LOG_DEBUG ;;
  [Ww][Aa][Rr][Nn])     LOG_LEVEL=$LOG_WARN  ;;
  [Ee][Rr][Rr][Oo][Rr]) LOG_LEVEL=$LOG_ERROR ;;
  [Ff][Aa][Tt][Aa][Ll]) LOG_LEVEL=$LOG_FATAL ;;
  *)                    LOG_LEVEL=$LOG_INFO  ;;
esac

log() {
  (
    LEVEL="$1"
    if [ "$LEVEL" -ge "$LOG_LEVEL" ]; then
      MSG="$2"
      SCOPE="$3"
      if [ -n "$SCOPE" ]; then
        if [ -n "$4" ]; then
          SCOPE="$SCOPE - $4"
        fi
      else
        SCOPE="$__MODULIZE_SCOPE"
      fi
      if [ -n "$SCOPE" ]; then
        SCOPE=" $SCOPE:"
      fi
      case "$LEVEL" in
        $LOG_DEBUG) LOG_NAME="$__MODULIZE_LOGGING_TEXT_DEBUG";;
        $LOG_INFO) LOG_NAME="$__MODULIZE_LOGGING_TEXT_INFO";;
        $LOG_WARN) LOG_NAME="$__MODULIZE_LOGGING_TEXT_WARN";;
        $LOG_ERROR) LOG_NAME="$__MODULIZE_LOGGING_TEXT_ERROR";;
        $LOG_FATAL) LOG_NAME="$__MODULIZE_LOGGING_TEXT_FATAL";;
        *) return 1;;
      esac
      TIMESTAMP="$(date +'%y-%m-%d %T')"
      while read line; do
        printf '%s\n' "$TIMESTAMP $LOG_NAME$SCOPE $line" >&2
      done<<__MODULIZE_LOG__
$MSG
__MODULIZE_LOG__
    fi
  )
}

logp() {
  log "$1" "$(cat -)" "$2" "$3"
}

scope() {
  if [ -z "$1" ]; then
    echo "$1"
  fi
  if [ -n "$2" ]; then
    __MODULIZE_SCOPE="$1 - $2"
  else
    __MODULIZE_SCOPE="$1"
  fi
}

debug() {
  log "$LOG_DEBUG" "$@"
}

info() {
  log "$LOG_INFO" "$@"
}

warn() {
  log "$LOG_WARN" "$@"
}

error() {
  log "$LOG_ERROR" "$@"
}

fatal() {
  log "$LOG_FATAL" "$@"
  exit 1
}

debugp() {
  logp "$LOG_DEBUG" "$@"
}

infop() {
  logp "$LOG_INFO" "$@"
}

warnp() {
  logp "$LOG_WARN" "$@"
}

errorp() {
  logp "$LOG_ERROR" "$@"
}

fatalp() {
  logp "$LOG_FATAL" "$@"
  exit 1
}

modname() {
  (
    NAME="$(
      printf %s "$1" | \
        head -1 | \
        tr '[:lower:]' '[:upper:]' | \
        sed -e 's/\./__/g' | \
        sed -e 's/[^A-Z0-9_]//g'
    )"
    printf %s "__MODULE__$NAME"
  )
}

modpath() {
  (
    NAME="$(
      printf %s "$1" | \
        head -1 | \
        tr '[:upper:]' '[:lower:]' | \
        sed -e 's/\./\//g' | \
        sed -e 's/[^a-z0-9_/]//g'
    )"
    printf %s "$ROOT/lib/$NAME.sh"
  )
}

use() {
  set -- "$1" "$(modname "$1")" "$(modpath "$1")"
  if [ -n "$(eval 'echo $'"$2")" ]; then
    debug "module '$1' already loaded" modulize use
  else
    debug "start loading module '$1'" modulize use
    . "$3"
    eval "$2=1"
    debug "module '$1' loaded" modulize use
  fi
}

CACHE_DIR="$ROOT/.cache"
BIN_DIR="$ROOT/bin"
LIB_DIR="$ROOT/lib"
LIBEXEC_DIR="$ROOT/libexec"

XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"

__MODULIZE__
