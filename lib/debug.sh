use quote
use print
use hex

debug_var() {
  (
    BLANK="$(
      if [ -n "$2" ]; then
        for _ in $(seq "$2"); do
          printf ' '
        done
      fi
    )"
    DQ='"'
    NAME="$(
      print "$1" | \
        head -1 | \
        grep -e '^[a-zA-Z_][0-9a-zA-Z_]*$'
    )"
    if [ -z "$NAME" ]; then
      fatal "invalid varialbe name '$NAME'" debug debug_var
    fi
    debug "$(eval "print $DQ$NAME=$BLANK"'$(quote "$'"$NAME"'")"')"
  )
}

debug_hex() {
  (
    BLANK="$(
      if [ -n "$2" ]; then
        for _ in $(seq "$2"); do
          printf ' '
        done
      fi
    )"
    DQ='"'
    NAME="$(
      print "$1" | \
        head -1 | \
        grep -e '^[a-zA-Z_][0-9a-zA-Z_]*$'
    )"
    if [ -z "$NAME" ]; then
      fatal "invalid varialbe name '$NAME'" debug debug_hex
    fi
    debug "$(eval "print $DQ$NAME=$BLANK"'0x$(print "$'"$NAME"'" | hexp)"')"
  )
}
