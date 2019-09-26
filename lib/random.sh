random_hex() {
  case "$1" in
    '') set -- 16;;
  esac
  od -An -tx8 -N"$1" /dev/urandom | tr -d '[ \n]'
}

random_u8() {
  od -An -tu8 -N1 /dev/urandom | tr -d '[ \n]'
}

random_i8() {
  od -An -td8 -N1 /dev/urandom | tr -d '[ \n]'
}

random_u16() {
  od -An -tu8 -N2 /dev/urandom | tr -d '[ \n]'
}

random_i16() {
  od -An -td8 -N2 /dev/urandom | tr -d '[ \n]'
}

random_u32() {
  od -An -tu8 -N4 /dev/urandom | tr -d '[ \n]'
}

random_i32() {
  od -An -td8 -N4 /dev/urandom | tr -d '[ \n]'
}

random_u64() {
  od -An -tu8 -N8 /dev/urandom | tr -d '[ \n]'
}

random_i64() {
  od -An -td8 -N8 /dev/urandom | tr -d '[ \n]'
}
