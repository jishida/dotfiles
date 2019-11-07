# pathmunge
pathmunge() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *)
      case "$2" in
        after) PATH="$PATH:$1";;
        *)     PATH="$1:$PATH";;
      esac
      ;;
  esac
}

# linuxbrew
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# PATH
pathmunge "$HOME/.local/bin"
pathmunge "$HOME/.yarn/bin"
pathmunge "$HOME/go/bin"
pathmunge "$HOME/.cargo/bin"

export PATH

# fzf
FZF_DEFAULT_COMMAND=''

if command -v rg >/dev/null 2>&1; then
  FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs --color never --no-messages --glob "!.git/"'
else
  if command -v ag >/dev/null 2>&1; then
    FZF_DEFAULT_COMMAND='ag -g ""'
  fi
fi

if command -v fd >/dev/null 2>&1; then
  if [ -z "$FZF_DEFAULT_COMMAND" ]; then
    FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --no-ignore-vcs --color never --exclude .git'
  fi
  FZF_ALT_C_COMMAND='fd --type d --hidden --follow --no-ignore-vcs --color never --exclude .git'
else
  if [ -z "$FZF_DEFAULT_COMMAND" ]; then
    FZF_DEFAULT_COMMAND='command find . -type d -name .git -prune -o -type f -print'
  fi
  FZF_ALT_C_COMMAND='command find . -type d -name .git -prune -o -type d -print'
fi

FZF_DEFAULT_OPTS='--layout=reverse --inline-info --border --preview "head -100 {}"'

if command -v tree >/dev/null 2>&1; then
  FZF_ALT_C_OPTS='--layout=reverse --preview "tree -C {} | head -100"'
else
  FZF_ALT_C_OPTS='--layout=reverse --preview "ls -a {} | head -100"'
fi

FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"

export FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS
export FZF_CTRL_T_COMMAND
export FZF_CTRL_T_OPTS
export FZF_ALT_C_COMMAND
export FZF_ALT_C_OPTS

# global
GTAGSCONF="$HOME/.globalrc"
GTAGSLABEL=native-pygments
export GTAGSCONF
export GTAGSLABEL

# direnv
if command -v direnv >/dev/null; then
  eval "$(direnv hook bash)"
fi

# nvm
init_nvm() {
  if [ -s "$1/nvm.sh" ]; then
    . "$1/nvm.sh"
    [ -s "$1/etc/bash_completion.d/nvm" ] && . "$1/etc/bash_completion.d/nvm"
    return 0
  fi
  return 1
}

export NVM_DIR="$HOME/.nvm"
init_nvm "$HOME/.config/nvm" || init_nvm "/home/linuxbrew/.linuxbrew/opt/nvm"
unset -f init_nvm
