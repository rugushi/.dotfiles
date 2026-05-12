export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="awesomepanda"

plugins=(git tmux golang zsh-autosuggestions zsh-syntax-highlighting)

#zsh tmux auto start
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false

source $ZSH/oh-my-zsh.sh

export export KUBE_EDITOR=nvim

alias k="kubectl"
alias ka="kubectl get all -o wide"
alias kap="kubectl apply -f "

alias t="terraform"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

[[ -f "$HOME/.dotfiles/zsh/dev-global.sh" ]] && source "$HOME/.dotfiles/zsh/dev-global.sh"
