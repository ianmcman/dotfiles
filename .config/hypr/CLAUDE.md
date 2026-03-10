# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Hyprland configuration using **KooL's Hyprland-Dots** from https://github.com/LinuxBeginnings. It's a Wayland compositor setup with a two-tier configuration system that separates default configs from user customizations.

## Configuration Architecture

### Two-Tier System

The configuration uses a layered approach:

1. **Default configs** (`configs/`): Base configurations that may be updated with upstream changes
2. **User configs** (`UserConfigs/`): User customizations that are preserved during updates

The main `hyprland.conf` sources default configs first, then user configs (which can override defaults).

### Key Directories

- `configs/` - Default configurations (keybinds, window rules, environment variables, system settings)
- `UserConfigs/` - User overrides and customizations - **edit these files for personal changes**
- `scripts/` - Default utility scripts (volume, brightness, screenshots, themes, etc.)
- `UserScripts/` - Custom user scripts - **add custom scripts here**
- `animations/` - Animation preset files
- `wallust/` - Generated color theme from wallpaper (via `wallust`)
- `Monitor_Profiles/` - Saved monitor profiles (created via `nwg-displays`)

### Main Configuration Files

| File | Purpose |
|------|---------|
| `hyprland.conf` | Entry point, sources all other configs |
| `UserConfigs/01-UserDefaults.conf` | Default apps (terminal, file manager, editor) |
| `UserConfigs/UserKeybinds.conf` | Custom keybinds (use `unbind` to override defaults) |
| `UserConfigs/UserSettings.conf` | Main Hyprland settings (input, gestures, misc) |
| `UserConfigs/UserDecorations.conf` | Window decorations, blur, shadows |
| `UserConfigs/UserAnimations.conf` | Animation configuration |
| `UserConfigs/WindowRules.conf` | Window/layer rules |
| `UserConfigs/Startup_Apps.conf` | Autostart applications |
| `UserConfigs/ENVariables.conf` | Environment variables |
| `hyprlock.conf` | Lock screen configuration |
| `hypridle.conf` | Idle management (screen lock, suspend) |

## Theming

Colors are generated from the current wallpaper using `wallust` and stored in `wallust/wallust-hyprland.conf`. This file is sourced by `UserDecorations.conf` and `hyprlock.conf` for dynamic theming.

## Key Variables

Defined in multiple locations:
- `$mainMod = SUPER` - Main modifier key
- `$scriptsDir = $HOME/.config/hypr/scripts`
- `$UserScripts = $HOME/.config/hypr/UserScripts`
- `$term` and `$files` - Set in `UserConfigs/01-UserDefaults.conf`

## Common Operations

### Reload Configuration
Most config changes require a Hyprland reload. Use:
```
hyprctl reload
```
Or press `SUPER+ALT+R` to refresh waybar and menus.

### Apply Wallpaper and Theme
```bash
wallust run -s /path/to/wallpaper
swww img /path/to/wallpaper
~/.config/hypr/scripts/WallustSwww.sh
```
Or use `SUPER+W` for wallpaper selection menu.

### Keybind Search
Press `SUPER+SHIFT+K` to open the keybind search menu (rofi-based).

## Notes

- **Do not rename files** in `UserConfigs/` - they are sourced by name from `hyprland.conf`
- `UserConfigs/` and `UserScripts/` directories are preserved when running the upgrade script
- Monitor configuration is managed via `nwg-displays` and stored in `monitors.conf` and `workspaces.conf`
- For NVIDIA GPUs, uncomment the relevant environment variables in `UserConfigs/ENVariables.conf`