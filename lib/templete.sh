use quote

templete() {
  set -- "$(
    if [ -p /dev/stdin ]; then
      cat - | dquote
    else
      dquote "$1"
    fi
  )"

  cat -<<__TEMPLETE__
$(eval "printf %s $1")
__TEMPLETE__
}
