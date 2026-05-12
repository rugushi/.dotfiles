#!/usr/bin/env bash
set -euo pipefail

STATE="./state"

export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

. stows.sh

for dir in "${stows[@]}"; do
  if [ -d ".dotfiles/$dir" ]; then
    echo "Unstowing: $dir"
    stow -D -d ".dotfiles" -t "$HOME" "$dir" || true
  fi
done

if [ -f "$STATE/brew-formula.txt" ]; then
  while read -r pkg; do
    if brew list --formula | grep -qx "$pkg"; then
      echo "Uninstalling: $pkg"
      brew uninstall "$pkg" || true
    fi
  done < "$STATE/brew-formula.txt"
fi

if [ -f "$STATE/brew-cask.txt" ]; then
  while read -r cask; do
    if brew list --cask | grep -qx "$cask"; then
      echo "Uninstalling cask: $cask"
      brew uninstall --cask "$cask" || true
    fi
  done < "$STATE/brew-cask.txt"
fi

if [ -f "$STATE/taps.txt" ]; then
  while read -r tap; do
    brew untap "$tap" || true
  done < "$STATE/taps.txt"
fi

brew autoremove || true
brew cleanup -s || true

rm -rf "$HOME/.oh-my-zsh" || true
rm -rf "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || true
rm -rf "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || true

[ -f "$STATE/zshrc.backup" ] && cp "$STATE/zshrc.backup" "$HOME/.zshrc"
[ -f "$STATE/zprofile.backup" ] && cp "$STATE/zprofile.backup" "$HOME/.zprofile"
