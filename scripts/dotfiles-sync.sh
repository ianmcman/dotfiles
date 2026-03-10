#!/bin/bash
# Dotfiles sync script — pull on login, push on logout
set -e

CONFIG="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

case "$1" in
  pull)
    echo "[dotfiles-sync] Pulling latest changes..."
    $CONFIG pull --rebase origin main 2>&1 || {
      echo "[dotfiles-sync] Pull failed (possibly no commits yet or no network). Skipping."
      exit 0
    }
    echo "[dotfiles-sync] Pull complete."
    ;;
  push)
    echo "[dotfiles-sync] Checking for changes..."
    bash "$HOME/scripts/gen-packages.sh"
    $CONFIG add -u
    if ! $CONFIG diff --cached --quiet; then
      $CONFIG commit -m "auto: $(date '+%Y-%m-%d %H:%M')"
      $CONFIG push origin main
      echo "[dotfiles-sync] Changes pushed."
    else
      echo "[dotfiles-sync] No changes to push."
    fi
    ;;
  *)
    echo "Usage: dotfiles-sync.sh [pull|push]"
    exit 1
    ;;
esac
