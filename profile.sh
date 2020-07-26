export EDITOR=vim

# linuxbrew
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# PATH
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

pathmunge "$HOME/.local/bin"
pathmunge "$HOME/.yarn/bin"
pathmunge "$HOME/go/bin"
pathmunge "$HOME/.cargo/bin"
unset -f pathmunge
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

# pyenv
if [ -x "$HOME/.pyenv/bin/pyenv" ]; then
  PYENV_ROOT="$HOME/.pyenv"
  PATH="$PYENV_ROOT/bin:$PATH"
  export PYENV_ROOT
  export PATH
  eval "$(pyenv init -)"
fi

# ssh-agent

init_ssh_agent() {
  command -v ssh-agent>/dev/null||return 1
  set -- "$(
    cmd='ssh-agent -s'
    pid_file="$HOME/.ssh/agent-pid"
    sock_file="$HOME/.ssh/agent-sock"
    pid="$(cat "$pid_file" 2>/dev/null)"
    sock="$(cat "$sock_file" 2>/dev/null)"
    has_cache=1
    expr "$pid" : '^[0-9]\+$'>/dev/null \
      || has_cache=0
    if [ $has_cache -eq 1 ]; then
      test -S "$sock" \
        || has_cache=0
      if [ $has_cache -eq 1 ]; then
        test "$cmd" = "$(
          ps -e -o uid,pid,cmd \
            | awk -vUID="$(id -u)" -vPID=$pid '$1==UID&&$2==PID{print}' \
            | sed -e 's/\s*[0-9]\+\s*[0-9]\+\s*//'
        )" || has_cache=0
      fi
    fi
    if [ $has_cache -eq 1 ]; then
      SSH_AGENT_PID="$pid"
      SSH_AUTH_SOCK="$sock"
    else
      env="$($cmd)"
      eval "$env">/dev/null
    fi
    test -n "$SSH_AGENT_PID"||return 1
    test -n "$SSH_AUTH_SOCK"||return 1
    if [ $has_cache -eq 0 ]; then
      (
        umask 0177
        echo "$SSH_AGENT_PID">"$pid_file"
        echo "$SSH_AUTH_SOCK">"$sock_file"
      )
    fi
    printf '%s\n%s' "$SSH_AGENT_PID" "$SSH_AUTH_SOCK"
  )"
  test $? -ne 0&&return 1
  SSH_AGENT_PID="$(printf %s "$1"|head -1)"
  SSH_AUTH_SOCK="$(printf %s "$1"|tail -1)"
  export SSH_AGENT_PID
  export SSH_AUTH_SOCK
}

if [ -n "$SSH_AGENT_ENABLED" ]; then
  init_ssh_agent || echo 'failed to initialize ssh-agent'
fi
unset -f init_ssh_agent
