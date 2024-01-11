#!/bin/sh

alias dg-login='kinit andreas.exer@INTRANET.DIGITEC'
alias ktest='kubectl config use-context $(kubectl config get-contexts -o name | grep k8s-tes)'
alias kprod='kubectl config use-context $(kubectl config get-contexts -o name | grep k8s-pro)'
alias k9='k9s -n dg-sales'

alias l='eza -l --icons --git --no-user'
alias ll='eza -l --icons --git -a'
alias lt='eza --tree --level=2 --long --icons --git'

alias cat='bat'

alias df='df -h'
alias free='free -m'
