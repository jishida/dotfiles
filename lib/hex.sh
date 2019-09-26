use print

hexp() {
  cat - | od -An -tx1 | tr -d '[ \n]'
}

hex() {
  print "$1" | hexp
}
