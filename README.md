# dotfiles

Ian's CachyOS / Hyprland configuration, managed with a bare git repo.

## Quick Install (new machine)

```bash
curl -fsSL https://raw.githubusercontent.com/ianmcman/dotfiles/main/install.sh | bash
```

This will:
1. Clone the repo
2. Check out all configs to `$HOME`
3. Install packages from `packages-explicit.txt` via paru
4. Enable the auto-sync systemd service

---

## Daily Use

| Command | What it does |
|---------|-------------|
| `config status` | Show tracked files with changes |
| `config add ~/.config/app/` | Start tracking a new app's config |
| `config diff` | See what changed |
| `config commit -m "msg"` | Commit changes manually |
| `dotsync` | Commit + push all changes now |

### Auto-sync

A systemd user service handles sync automatically:
- **On login** — pulls latest changes from GitHub
- **On logout** — commits any changes and pushes

Check service status:
```bash
systemctl --user status dotfiles-sync
```

---

## What's Tracked

- `~/.config/hypr/` — Hyprland WM + scripts
- `~/.config/fish/` — Fish shell config
- `~/.config/waybar/`, `rofi/`, `swaync/` — Bar, launcher, notifications
- `~/.config/alacritty/`, `kitty/`, `ghostty/`, `wezterm/` — Terminals
- `~/.config/btop/`, `cava/`, `fastfetch/` — System monitors
- `~/.config/gtk-3.0/`, `gtk-4.0/`, `Kvantum/`, `qt5ct/`, `qt6ct/`, `fontconfig/`, `wallust/` — Theming
- `~/.config/ags/`, `quickshell/` — Shell widgets
- `~/.gitconfig`, `~/.zshrc`, `~/.gtkrc-2.0` — Home dotfiles
- `~/packages-explicit.txt`, `~/packages-aur.txt` — Package lists (auto-updated on sync)
- `~/scripts/` — Sync and package helper scripts

### Not Tracked (intentionally excluded)

Discord, Signal, Firefox, Obsidian, VS Code, Claude state, SSH keys, browser profiles, caches.

---

## Adding New Files

```bash
config add ~/.config/newapp/
config commit -m "add: newapp config"
config push
```

Or just run `dotsync` after adding.

---

## How It Works

A **bare git repo** lives at `~/.dotfiles/`. The `config` alias points git at it with `$HOME` as the work-tree, so files are tracked in place — no symlinks, no copies.

```bash
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
