#!/bin/bash
# Dotfiles bootstrap installer
# Usage: curl -fsSL https://raw.githubusercontent.com/ianmcman/dotfiles/main/install.sh | bash
set -e

GITHUB_USER="ianmcman"
REPO="https://github.com/${GITHUB_USER}/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "==> Dotfiles installer for ${GITHUB_USER}"
echo ""

# Install git if missing
if ! command -v git &>/dev/null; then
  echo "==> Installing git..."
  sudo pacman -S --noconfirm git
fi

# Clone bare repo
if [ -d "$DOTFILES_DIR" ]; then
  echo "==> ~/.dotfiles already exists, skipping clone"
else
  echo "==> Cloning dotfiles repo..."
  git clone --bare "$REPO" "$DOTFILES_DIR"
fi

# Define config helper
config() {
  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

config config status.showUntrackedFiles no

# Back up any conflicting files before checkout
echo "==> Backing up conflicting files to ~/.dotfiles-backup/ ..."
mkdir -p "$HOME/.dotfiles-backup"
conflicts=$(config checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' || true)
if [ -n "$conflicts" ]; then
  echo "$conflicts" | while read -r f; do
    dest="$HOME/.dotfiles-backup/$(dirname "$f")"
    mkdir -p "$dest"
    mv "$HOME/$f" "$dest/" 2>/dev/null || true
  done
  echo "==> Backed up conflicting files."
fi

# Checkout dotfiles
echo "==> Checking out dotfiles..."
config checkout

# Add zsh alias (fish alias comes from the tracked conf.d file)
if ! grep -q "alias config=" "$HOME/.zshrc" 2>/dev/null; then
  echo "" >> "$HOME/.zshrc"
  echo "# Dotfiles management via bare git repo" >> "$HOME/.zshrc"
  echo "alias config='git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> "$HOME/.zshrc"
  echo "alias dotsync='bash \$HOME/scripts/dotfiles-sync.sh push'" >> "$HOME/.zshrc"
fi

# Make scripts executable
chmod +x "$HOME/scripts/gen-packages.sh" "$HOME/scripts/dotfiles-sync.sh" 2>/dev/null || true

# Enable systemd sync service
echo "==> Enabling dotfiles-sync systemd service..."
systemctl --user daemon-reload
systemctl --user enable dotfiles-sync.service
systemctl --user start dotfiles-sync.service

# Install packages
if [ -f "$HOME/packages-explicit.txt" ]; then
  echo ""
  echo "==> Installing packages from packages-explicit.txt..."

  # Install paru if missing
  if ! command -v paru &>/dev/null; then
    echo "==> Installing paru (AUR helper)..."
    sudo pacman -S --needed --noconfirm base-devel
    git clone https://aur.archlinux.org/paru.git /tmp/paru-install
    (cd /tmp/paru-install && makepkg -si --noconfirm)
    rm -rf /tmp/paru-install
  fi

  paru -S --needed --noconfirm - < "$HOME/packages-explicit.txt" || {
    echo "==> Some packages failed to install — check output above."
  }
fi

echo ""
echo "=============================="
echo " Dotfiles installed!"
echo "=============================="
echo ""
echo "  config status     — see tracked file status"
echo "  config add <file> — track a new file"
echo "  dotsync           — manually push changes"
echo ""
echo "The sync service will auto-pull on next login and push on logout."
