use print

escape_lfp() {
  set -- "$(
    (cat -;printf _)| \
      awk -vRS=_ -vORS=_ '{gsub(/\\/,"\\\\");gsub(/\n/,"\\n");print}'
  )"
  print "${1%_}"
}

escape_lf() {
  print "$1" | escape_lfp
}

# unescape_lfp() {
#   cat - | \
#     sed -e 's/\([^\]\(\\\\\)*\)\\n/\1\n/g' | \
#     sed -e 's/^\(\(\\\\\)*\)\\n/\1\n/g' | \
#     sed -e 's/\\\\/\\/g'
# }

unescape_lfp() {
  set -- "$(
    (cat -;printf _)| \
      awk -vRS=_ -vORS=_ '{
r=""
s=$0
while(match(s,/((^|[^\\])(\\\\)*)\\n/)>0){
r=r substr(s,1,RSTART+RLENGTH-3) "\n"
s=substr(s,RSTART+RLENGTH)
}
r=r s
gsub(/\\\\/,"\\",r)
print r
}'
  )"
  print "${1%_}"
}

unescape_lf() {
  print "$1" | unescape_lfp
}
