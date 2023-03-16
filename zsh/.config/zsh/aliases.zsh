#!/bin/sh

# work
alias dg-login='kinit andreas.exer@INTRANET.DIGITEC && MssqlKerberos'
alias ktest="kubectl config use-context test"
alias kprod="kubectl config use-context prod"
alias k9="k9s -n dg-sales"

# ls
alias l='exa -l --icons --git --no-user'
alias ll='exa -l --icons --git -a'
alias lt='exa --tree --level=2 --long --icons --git'

alias cat='bat'
alias zsh-update-plugins="find "$ZDOTDIR/plugins" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"

alias df='df -h'
alias free='free -m'
