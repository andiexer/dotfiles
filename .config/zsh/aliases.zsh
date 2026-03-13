#!/bin/sh

alias dg-login='kinit andreas.exer@INTRANET.DIGITEC'
alias kdev='kubectl config use-context $(kubectl config get-contexts -o name | grep dg-core-dev)'
alias ktest='kubectl config use-context $(kubectl config get-contexts -o name | grep dg-core-tes)'
alias kprod='kubectl config use-context $(kubectl config get-contexts -o name | grep dg-core-pro)'
alias k9='k9s -n dg-sales'
alias klocal='kubectl config use-context rancher-desktop'
alias k='kubectl'


alias l='eza -l --icons --git --no-user'
alias ll='eza -l --icons --git -a'
alias lt='eza --tree --level=2 --long --icons --git'

alias cat='bat'

alias df='df -h'
alias free='free -m'
