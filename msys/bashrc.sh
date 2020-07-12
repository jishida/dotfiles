USERHOME="/$(printf '%s' "${USERPROFILE%%:*}" | tr A-Z a-z)$(printf '%s' "${USERPROFILE#*:}" | tr '\\' '/')"
MSYS2_HOME=/c/msys64

quote() {
  set -- "$1" "$(cat -<<__MOD_QUOTE_QUOTEP_AWK_SCRIPT__
{gsub(/'/,"'\"'\"'");print}
__MOD_QUOTE_QUOTEP_AWK_SCRIPT__
  )"
  set -- "$(
    printf %s_ "$1" | \
      awk -vRS=_ -vORS=_ "$2"
  )"
  printf %s "'${1%_}'"
}

append() {
  export PATH="$PATH:$1"
}

scoop_bin() {
  case "$2" in
    '')
      printf '%s' "$USERHOME/scoop/apps/$1/current/bin"
      ;;
    '.')
      printf '%s' "$USERHOME/scoop/apps/$1/current"
      ;;
    *)
     printf '%s' "$USERHOME/scoop/apps/$1/current/$2"
      ;;
  esac
}

scoop_alias() {
  for file in $(ls "$(scoop_bin "$1" "$2")")
  do
    case "$file" in
      *'.bat')
        alias "${file%.bat}=$file"
        ;;
      *'.cmd')
        alias "${file%.cmd}=$file"
        ;;
      *'.BAT')
        alias "${file%.BAT}=$file"
        ;;
      *'.CMD')
        alias "${file%.CMD}=$file"
        ;;
    esac
  done
}

scoop_append() {
  append "$(scoop_bin "$1" "$2")"
}

vagrant_machine() {
  (
    CD="$(pwd)"
    VD="$HOME/vagrant/$1"
    cd "$VD"
    if [ $? -ne 0 ]
    then
      echo "unknown machine: $1"
      return 1
    fi
    shift 1
    case "$1" in
      start) vagrant up;;
      stop) vagrant halt;;
      restart) vagrant reload;;
      edit) vim Vagrantfile;;
      cp)
        SSH_CONFIG="$VD/.ssh/config"
        [ ! -d .ssh ] && mkdir .ssh
        vagrant ssh-config>"$SSH_CONFIG"
        if [ $? -eq 0 ]; then
          shift 1
          cd "$CD"
          scp -F "$SSH_CONFIG" "$@"
        fi
        ;;
      '') vagrant ssh;;
      *) vagrant "$@";;
    esac
  )
}

vagrant_alias() {
  alias "$1=vagrant_machine $1"
}

scoop_alias dart
scoop_alias android-sdk tools/bin

alias docker='winpty docker'

vagrant_alias ubuntu1904
vagrant_alias fedora30
vagrant_alias freebsd12
vagrant_alias centos7
vagrant_alias openindiana-hipster

VAGRANT_CURRENT_UBUNTU=ubuntu1904
VAGRANT_CURRENT_FEDORA=fedora30
VAGRANT_CURRENT_FREEBSD=freebsd12
VAGRANT_CURRENT_CENTOS=centos7
VAGRANT_CURRENT_INDIANA=openindiana-hipster

alias ubuntu="$VAGRANT_CURRENT_UBUNTU"
alias fedora="$VAGRANT_CURRENT_FEDORA"
alias freebsd="$VAGRANT_CURRENT_FREEBSD"
alias centos="$VAGRANT_CURRENT_CENTOS"
alias indiana="$VAGRANT_CURRENT_INDIANA"

alias hyperv="$USERHOME/scripts/hypervisor.bat"

# for tmux 256 color support
alias tmux='tmux -2'

# configure fzf
[ -f ~/.fzf.bash ] && . ~/.fzf.bash

# aliases for git
GIT_COMMANDS="$(cat -<<EOS
clone init
add mv reset rm
bisect grep log show status
branch checkout commit diff merge rebase tag
fetch pull push
help
stash
EOS
)"

for c in $GIT_COMMANDS; do
  alias "g$c=git $c"
done

unset -v c

# neovim
alias nvim=$(quote "$DOTFILES_HOME/msys/bin/nvim-proxy")
