#!/usr/bin/env bash
# /* ---- 💫 https://github.com/LinuxBeginnings 💫 ---- */  ##
# Rofi-based Quick Cheat Sheet (replacement for yad version)

# Kill existing rofi instance
pkill rofi

# Create hints text
HINTS=$(cat << 'EOF'
ESC                    close this app
SUPER (=)              SUPER KEY (Windows Key Button)
SUPER+SHIFT+K          Searchable Keybinds
SUPER+SHIFT+E          KooL Hyprland Settings Menu

SUPER+ENTER            Terminal (kitty)
SUPER+SHIFT+ENTER      DropDown Terminal (Q to close)
SUPER+B                Launch Browser
SUPER+A                Desktop Overview (AGS)
SUPER+D                Application Launcher (rofi)
SUPER+E                Open File Manager (Thunar)
SUPER+S                Google Search using rofi
SUPER+T                Global theme switcher
SUPER+Q                Close active window (not kill)
SUPER+SHIFT+Q          Kill active window
SUPER+ALT+↑/↓          Desktop Zoom/Magnifier
SUPER+ALT+V            Clipboard Manager (cliphist)
SUPER+W                Choose wallpaper
SUPER+SHIFT+W          Wallpaper effects
CTRL+ALT+W             Random wallpaper

CTRL+ALT+B             Hide/UnHide Waybar
CTRL+B                 Choose waybar styles
ALT+B                  Choose waybar layout
ALT+R                  Reload Waybar swaync Rofi
SUPER+SHIFT+N          Launch Notification Panel

PRINT                  Screenshot (grim)
SHIFT+PRINT            Screenshot region (grim + slurp)
SHIFT+S                Screenshot region (swappy)
CTRL+PRINT             Screenshot timer 5 secs
CTRL+SHIFT+PRINT       Screenshot timer 10 secs
ALT+PRINT              Screenshot active window

CTRL+ALT+P             Power menu (wlogout)
CTRL+ALT+L             Screen lock (hyprlock)
CTRL+ALT+DEL           Hyprland Exit

SUPER+SHIFT+F          Fullscreen
CTRL+F                 Fake Fullscreen
ALT+L                  Toggle Dwindle | Master Layout
SPACEBAR               Toggle float (single window)
ALT+SPACEBAR           Toggle float (all windows)
ALT+O                  Toggle Blur
CTRL+O                 Toggle Opaque
SUPER+SHIFT+A          Animations Menu
CTRL+R                 Rofi Themes Menu
CTRL+SHIFT+R           Rofi Themes Menu v2
SUPER+SHIFT+G          Gamemode (toggle animations)
ALT+E                  Rofi Emoticons
SUPER+H                Launch this Quick Cheat Sheet

More info: https://github.com/LinuxBeginnings/Hyprland-Dots/wiki
EOF
)

# Show hints in rofi
echo "$HINTS" | rofi -dmenu -p "Quick Cheat Sheet" -theme-str 'window {width: 50%;} listview {lines: 12;}' -no-custom
