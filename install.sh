#!/usr/bin/env bash


if which brew &> /dev/null; then
	echo "homebrew is already installed"
else
	echo "installing homebrew"
        #brew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        brew update
        brew upgrade
fi

. packages/packages.sh


#oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

#brew for m chip
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/"$(whoami)"/.zprofile && eval "$(/opt/homebrew/bin/brew shellenv)"

#install packages
for app in "${apps[@]}"; do
    brew install "$app"
done
for cask in "${casks[@]}"; do
    brew install --cask "$cask"
done
for font in "${fonts[@]}"; do
    brew install --cask "$font"
done

#symlink
. stows.sh
for dir in "${stows[@]}"; do
    stow --adopt "$dir"
done

#reset context to init if already exists
git --reset hard

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

