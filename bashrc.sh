# nodejs-yarn -> yarn
command -v nodejs-yarn >/dev/null 2>&1 && alias yarn=nodejs-yarn

# for tmux 256 color support
alias tmux='tmux -2'

# crontab
alias cronedit='crontab -e'

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

alias vimmerge='git mergetool -t vimdiff'

# umask
umask 022

# ll alias
command -v ll >/dev/null 2>&1 || alias ll='ls -la'

# alias for gtags
alias gtags-ctags='gtags --gtagslabel=ctags'
alias gtags-new-ctags='gtags --gtagslabel=new-ctags'
alias gtags-pygments='gtags --gtagslabel=pygments'

# nvim alias
e() {
  (
    if [ -d "$1" ]; then
      cd "$1"
      nvim
      return
    fi
    if [ -f "$1" ]; then
      cd "$(dirname "$1")"
      set -- "$(basename "$1")"
    fi
    if [ -n "$1" ]; then
      nvim "$1"
    else
      nvim
    fi
  )
}
