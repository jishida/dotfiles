use print

quotep() {
  set -- "$(cat -<<__MOD_QUOTE_QUOTEP_AWK_SCRIPT__
{gsub(/'/,"'\"'\"'");print}
__MOD_QUOTE_QUOTEP_AWK_SCRIPT__
  )"
  set -- "$(
    (cat -;printf _)| \
      awk -vRS=_ -vORS=_ "$1"
  )"
  print "'${1%_}'"
}

quote() {
  print "$1" | quotep
}

dquotep() {
  set -- "$(
    (cat -;printf _)| \
      awk -vRS=_ -vORS=_ '{gsub(/\\/,"\\\\");gsub(/"/,"\\\"");print}'
  )"
  print '"'"${1%_}"'"'
}

dquote() {
  print "$1" | dquotep
}
