#!/bin/bash
# Generate package lists for dotfiles repo
pacman -Qe | awk '{print $1}' > "$HOME/packages-explicit.txt"
pacman -Qm | awk '{print $1}' > "$HOME/packages-aur.txt"
echo "Package lists updated: packages-explicit.txt ($(wc -l < "$HOME/packages-explicit.txt") pkgs), packages-aur.txt ($(wc -l < "$HOME/packages-aur.txt") AUR pkgs)"
