#!/usr/bin/env bash
# install.sh — link dotfiles based on .installlist
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
INSTALL_LIST="$DOTFILES_DIR/.installlist"
BACKUPS_ROOT="$DOTFILES_DIR/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$BACKUPS_ROOT/$TIMESTAMP"

mkdir -p "$BACKUP_DIR"

link_item() {
    local src="$DOTFILES_DIR/$1"
    local dest="$HOME/$1"

    mkdir -p "$(dirname "$dest")"

    if [[ -e "$dest" && ! ( -L "$dest" && "$(readlink "$dest")" == "$src" ) ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$1")"
        echo "🔸  Backing up $dest → $BACKUP_DIR/$1"
        mv "$dest" "$BACKUP_DIR/$1"
    fi

    ln -sf "$src" "$dest"
    echo "✅  Linked $dest → $src"
}

echo "🔧 Using install list: $INSTALL_LIST"
while IFS= read -r item || [[ -n "$item" ]]; do
    # Skip empty lines or comments
    [[ -z "$item" || "$item" =~ ^# ]] && continue

    link_item "$item"
done < "$INSTALL_LIST"

echo -e "\n🎉 All dotfiles linked. Backups (if any) stored in $BACKUP_DIR"
