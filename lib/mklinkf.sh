use mklink
use mkdirall
use rmall

mklinkf() {
  if [ -L "$2" ] || [ -e "$2" ]; then
    rmall "$2" "$3" "$4"
  else
    mkdirall "$(dirname "$2")"
  fi
  mklink "$1" "$2" "$3" "$4"
}
