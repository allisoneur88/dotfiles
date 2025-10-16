#!/usr/bin/env bash
# setup.sh - bare-bones Arch/WSL bootstrap
set -euo pipefail

echo "Starting minimal setupp ..."

# Install core packages
sudo pacman -Sy --needed --noconfirm zsh oh-my-zsh tmux neovim git curl

