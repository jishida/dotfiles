export GOPATH=$USERHOME/go
export XDG_CONFIG_HOME="$HOME/.config"

append "$USERHOME/bin"
append "$GOPATH/bin"
append "$USERHOME/.cargo/bin"
scoop_append corretto8
scoop_append dart
scoop_append nvm .
scoop_append nvm nodejs/nodejs
scoop_append yarn Yarn/bin
scoop_append yarn global/node_modules/.bin
scoop_append android-sdk tools/bin
append "$USERHOME/scoop/shims"

export PATH="$PATH:/c/Program Files/Docker/Docker/Resources/bin"
