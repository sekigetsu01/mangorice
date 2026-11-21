typeset -U path PATH
path=("$HOME/.local/bin" $path /usr/lib/qt6/bin)
export PATH
export EDITOR=nvim VISUAL=nvim
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

[[ $XDG_SESSION_TYPE == tty && "$(tty)" == "/dev/tty1" ]] && exec mango
