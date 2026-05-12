export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="fino"

plugins=(git golang)

source $ZSH/oh-my-zsh.sh

export export KUBE_EDITOR=nvim

alias k="kubectl"
alias ka="kubectl get all -o wide"
alias kap="kubectl apply -f "
alias o="opentofu"
