# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

custom_path=":$HOME/.local/bin:$HOME/bin"
# User specific environment
if ! [[ "$PATH" =~ "$custom_path" ]]; then
    PATH+="$custom_path"
fi
export PATH
export KAKOUNE_RUNTIME=/usr/local/share/kak
export KAKOUNE_POSIX_SHELL=/usr/bin/bash
export EDITOR=kak
export VISUAL=$EDITOR

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups

shopt -s histappend dirspell cdspell cmdhist

# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export TERM="xterm-256color"

bind -x '"\C-l": ls -AhlX --group-directories-first'
bind -x '"\C-g": goto'

alias pactivate='source ./.venv/bin/activate'
alias ..='cd ..'
alias ...='cd ../..'

kman() { kak -e "man $1"; }

kc() {
    s=$(kak -l | wmenu $WMENU_OPTS)
    if [ -n "$s" ]; then
        kak -c "$s"
    fi
}
alias k='kak'
alias kgrep='ke "live-grep"'

alias dots='/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME'
alias dotsdo='dots commit -a -m "oh hi mark" ; dots push'

alias up='sudo dnf update -y; rustup update'

. "$HOME/.cargo/env"
