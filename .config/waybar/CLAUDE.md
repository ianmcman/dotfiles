# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a highly customized **Waybar** configuration for a Wayland desktop environment. Waybar is a highly customizable status bar for Wayland compositors (primarily Hyprland, GNOME, KDE Plasma on Wayland, etc.). The configuration is split into modular files to manage complexity and support multiple layout variations.

**Key Technologies:**
- **Waybar**: Status bar/taskbar for Wayland
- **Hyprland**: Wayland window manager (primary target based on modules)
- **JSON + CSS**: Configuration format (waybar uses JSON for modules, CSS for styling)
- **Custom Scripts**: External shell scripts (from `$HOME/.config/hypr/scripts/`) for advanced functionality

## Architecture

This setup uses a **modular configuration approach** where the main config files include smaller modules. This prevents duplication and makes maintenance easier.

### Core Files Structure

```
waybar/
├── config                         # Symlink to active configuration
├── style.css                      # Symlink to active style theme
├── configs/                       # 47+ different layout configurations
│   ├── TOP-Default-Laptop         # Example: top bar, laptop-optimized
│   ├── BOT-Simple                 # Example: bottom bar, minimal
│   ├── [TOP & BOT] SummitSplit*   # Stacked top+bottom configurations
│   └── ...
├── Modules                        # Standard Waybar module definitions (10.5K lines)
│   └── Includes: temperature, backlight, battery, bluetooth, clock, cpu,
│       disk, language, submap, window, idle_inhibitor, keyboard-state,
│       memory, mpris, network, power-profiles, pulseaudio, tray, etc.
├── ModulesCustom                  # Custom modules (7.9K lines)
│   └── Weather, file manager, terminal, browser, system monitors, etc.
├── ModulesWorkspaces              # Hyprland workspace module variations
│   └── Different visual styles: circles, roman numerals, numbers, etc.
├── ModulesGroups                  # Module groups (dropdowns/drawers)
│   └── Groups like: app_drawer, motherboard, laptop, audio, connections, etc.
├── ModulesVertical                # Vertical bar variants
├── UserModules                    # User-defined custom modules (empty or user additions)
├── style/                         # 40+ CSS theme files
│   └── Catppuccin themes, custom color schemes, vertical bar styles, etc.
└── wallust/                       # Color palette files (likely for dynamic theming)
```

### Module Relationship

Most configurations use the `"include"` directive to compose modules:

```json
"include": [
  "$HOME/.config/waybar/Modules",
  "$HOME/.config/waybar/ModulesWorkspaces",
  "$HOME/.config/waybar/ModulesCustom",
  "$HOME/.config/waybar/ModulesGroups",
  "$HOME/.config/waybar/UserModules"
]
```

This means:
1. A config defines layout (position, spacing, which modules to display)
2. Modules are defined in separate files
3. Styles are applied via CSS

## Common Development Tasks

### Switching to a Different Layout

The active configuration is determined by the `config` symlink:

```bash
# View current active config
ls -l ~/.config/waybar/config

# Switch to a different layout (example)
ln -sf ~/.config/waybar/configs/BOT-Default ~/.config/waybar/config

# Reload Waybar
pkill -SIGUSR2 waybar  # Reload config only
pkill waybar           # Full restart
```

### Switching Themes/Styles

The active style is determined by the `style.css` symlink:

```bash
# View current active style
ls -l ~/.config/waybar/style.css

# Switch to a different theme
ln -sf ~/.config/waybar/style/Catppuccin-Mocha.css ~/.config/waybar/style.css

# Reload Waybar
pkill -SIGUSR2 waybar
```

### Adding a New Module

1. **Define the module** in the appropriate file:
   - `Modules` - Standard Waybar modules
   - `ModulesCustom` - Custom/script-based modules
   - `ModulesVertical` - Vertical layout variants
   - `UserModules` - User-specific modules

2. **Add to a config layout**:
   ```json
   "modules-left": ["custom/weather", "clock"]
   ```

3. **Style if needed** in an active CSS theme file

### Adding a New Style/Theme

1. Create a new `.css` file in `style/` directory
2. Follow existing theme patterns (Catppuccin, dark/light modes, etc.)
3. Key CSS selectors to style:
   - `#waybar` - main bar container
   - `#clock`, `#memory`, `#cpu` - individual modules
   - `.modules-left`, `.modules-center`, `.modules-right` - layout sections
   - `button` - module buttons/widgets

4. Symlink to activate:
   ```bash
   ln -sf ~/.config/waybar/style/YourTheme.css ~/.config/waybar/style.css
   ```

### Testing Configuration Changes

1. **Syntax validation** - Waybar will show errors if JSON is invalid
2. **Reload without full restart**:
   ```bash
   pkill -SIGUSR2 waybar  # Reloads config and style
   ```
3. **Full restart** (if reload fails):
   ```bash
   killall waybar && waybar &
   ```

## Important Notes

- **External Scripts**: Many modules call scripts in `$HOME/.config/hypr/scripts/` (Hyprland config directory). These handle brightness, volume, system monitoring, etc.
- **Hyprland Integration**: This setup is tightly integrated with Hyprland. Some modules (workspace indicator, submap display) are Hyprland-specific.
- **JSON Format**: Waybar configs are JSON. Watch for trailing commas in last items within objects/arrays.
- **Symlink References**: Active config and style are determined by symlinks, not hardcoded paths.
- **Performance**: Large number of modules or frequent updates (interval: 1) can impact CPU usage.

## Waybar Documentation

For module-specific options and features:
- Official: https://github.com/Alexays/Waybar/wiki
- Module reference: https://man.archlinux.org/man/waybar.5

## Directory Key

- `configs/`: All layout variants (choose one as active)
- `style/`: All theme/color variants (choose one as active)
- `Modules*`: Module definitions (included by active config)
- `wallust/`: Dynamic color palette data
