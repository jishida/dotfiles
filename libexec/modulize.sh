#!/bin/sh

DQ='"'
printf '%s\n\n' "ROOT='$(cd "$(dirname "$0")/.."&&(pwd|sed -e "s/'/'$DQ'$DQ'/g"))'"

cat -<<'__MODULIZE__'
__MODULIZE_TPUT_VALID="$(command -v tput>/dev/null 2>&1&&echo 1||echo 0)"
__MODULIZE_COLOR_BLACK="$(test "$__MODULIZE_TPUT_VALID" -eq 1&&tput setaf 0)"
__MODULIZE_COLOR_RED="$(test "$__MODULIZE_TPUT_VALID" -eq 1&&tput setaf 1)"
__MODULIZE_COLOR_GREEN="$(test "$__MODULIZE_TPUT_VALID" -eq 1&&tput setaf 2)"
__MODULIZE_COLOR_YELLOW="$(test "$__MODULIZE_TPUT_VALID" -eq 1&&tput setaf 3)"
__MODULIZE_COLOR_BLUE="$(test "$__MODULIZE_TPUT_VALID" -eq 1&&tput setaf 4)"
__MODULIZE_COLOR_MAGENTA="$(test "$__MODULIZE_TPUT_VALID" -eq 1&&tput setaf 5)"
__MODULIZE_COLOR_CYAN="$(test "$__MODULIZE_TPUT_VALID" -eq 1&&tput setaf 6)"
__MODULIZE_COLOR_WHITE="$(test "$__MODULIZE_TPUT_VALID" -eq 1&&tput setaf 7)"
__MODULIZE_COLOR_RESET="$(test "$__MODULIZE_TPUT_VALID" -eq 1&&tput sgr0)"
__MODULIZE_LOGGING_TEXT_DEBUG="$(printf %s "$__MODULIZE_COLOR_BLUE[DEBUG]$__MODULIZE_COLOR_RESET")"
__MODULIZE_LOGGING_TEXT_INFO="$(printf  %s "$__MODULIZE_COLOR_GREEN[INFO]$__MODULIZE_COLOR_RESET")"
__MODULIZE_LOGGING_TEXT_WARN="$(printf  %s "$__MODULIZE_COLOR_YELLOW[WARN]$__MODULIZE_COLOR_RESET")"
__MODULIZE_LOGGING_TEXT_ERROR="$(printf %s "$__MODULIZE_COLOR_RED[ERROR]$__MODULIZE_COLOR_RESET")"
__MODULIZE_LOGGING_TEXT_FATAL="$(printf %s "$__MODULIZE_COLOR_MAGENTA[FATAL]$__MODULIZE_COLOR_RESET")"

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
  [Dd][Ee][Bb][Uu][Gg]|$LOG_DEBUG) LOG_LEVEL=$LOG_DEBUG ;;
  [Ww][Aa][Rr][Nn]    |$LOG_WARN ) LOG_LEVEL=$LOG_WARN  ;;
  [Ee][Rr][Rr][Oo][Rr]|$LOG_ERROR) LOG_LEVEL=$LOG_ERROR ;;
  [Ff][Aa][Tt][Aa][Ll]|$LOG_FATAL) LOG_LEVEL=$LOG_FATAL ;;
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
