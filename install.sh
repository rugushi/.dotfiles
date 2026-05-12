#!/usr/bin/env bash
set -euo pipefail

PKG="./packages/packages.json"

if command -v brew &>/dev/null; then
	echo "homebrew is already installed"
else
	echo "installing homebrew"
        #brew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        brew update
        brew upgrade
fi

#brew for m chip
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/"$(whoami)"/.zprofile && eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v jq &>/dev/null; then
  brew install jq
fi

#install packages
brew tap $(jq -r '.tap | join(" ")' "$PKG")

brew install $(jq -r '.base + .tool | join(" ")' "$PKG")

brew install --cask $(jq -r '.cask + .font | join(" ")' "$PKG")

#oh my zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

#symlink
. stows.sh

for dir in "${stows[@]}"; do
    stow --adopt "$dir"
done

export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

#reset context to init if already exists
# git --reset hard

# zsh-syntax-highlighting
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git -C "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" pull
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git -C "$ZSH_CUSTOM/plugins/zsh-autosuggestions" pull
else
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

#snapshot
mkdir -p state

brew list --formula > state/brew-formula.txt
brew list --cask > state/brew-cask.txt
brew tap > state/taps.txt
