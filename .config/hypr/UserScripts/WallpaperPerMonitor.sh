#!/usr/bin/env bash
# /* ---- 💫 https://github.com/LinuxBeginnings 💫 ---- */  ##
# Random wallpaper per monitor at regular intervals
# Each monitor can have its own wallpaper directory

set -euo pipefail

# Configuration: monitor -> directory mapping
# Edit these to match your setup
declare -A MONITOR_DIRS=(
    ["HDMI-A-1"]="/home/mcmanusiang/Pictures/Desktop"
    ["DP-3"]="/home/mcmanusiang/Pictures/Desktop - Ultrawide"
)

# Interval in seconds (3600 = 1 hour)
INTERVAL=3600

# Which monitor to use for wallust color generation
# Options: "first" (first in MONITOR_DIRS), "focused", or specific monitor name
COLOR_SOURCE_MONITOR="HDMI-A-1"

# Transition settings
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_TYPE=random
export SWWW_TRANSITION_DURATION=1
export SWWW_TRANSITION_BEZIER=".43,1.19,1,.4"

SCRIPTSDIR="$HOME/.config/hypr/scripts"

# Get image files from a directory
get_random_image() {
    local dir="$1"
    local ext_pattern="-iname *.jpg -o -iname *.jpeg -o -iname *.png -o -iname *.gif -o -iname *.bmp -o -iname *.tiff -o -iname *.webp -o -iname *.pnm"
    find -L "$dir" -type f \( $ext_pattern \) | shuf -n 1
}

# Check if directories exist
for monitor in "${!MONITOR_DIRS[@]}"; do
    dir="${MONITOR_DIRS[$monitor]}"
    if [[ ! -d "$dir" ]]; then
        echo "Error: Directory '$dir' for monitor '$monitor' does not exist"
        exit 1
    fi
done

# Ensure swww daemon is running
if ! pgrep -x "swww-daemon" >/dev/null; then
    swww-daemon --format xrgb &
    sleep 1
fi

echo "Starting wallpaper rotation for monitors: ${!MONITOR_DIRS[*]}"
echo "Interval: ${INTERVAL} seconds ($(($INTERVAL / 3600)) hour(s))"
echo "Color source monitor: $COLOR_SOURCE_MONITOR"

# Main loop
while true; do
    for monitor in "${!MONITOR_DIRS[@]}"; do
        dir="${MONITOR_DIRS[$monitor]}"
        img=$(get_random_image "$dir")

        if [[ -n "$img" && -f "$img" ]]; then
            echo "Setting wallpaper for $monitor: $img"
            swww img -o "$monitor" "$img" \
                --transition-fps 60 \
                --transition-type random \
                --transition-duration 1 \
                --transition-bezier ".43,1.19,1,.4"
        else
            echo "Warning: No image found for $monitor in $dir"
        fi
    done

    # Run wallust on the designated monitor's wallpaper for color theme
    color_monitor="$COLOR_SOURCE_MONITOR"
    if [[ "$color_monitor" == "focused" ]]; then
        color_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
    elif [[ "$color_monitor" == "first" ]]; then
        color_monitor="${!MONITOR_DIRS[@]}"
        color_monitor="${color_monitor%% *}"
    fi

    color_dir="${MONITOR_DIRS[$color_monitor]:-}"
    if [[ -n "$color_dir" && -d "$color_dir" ]]; then
        # Get the current wallpaper for the color source monitor from swww cache
        cache_file="$HOME/.cache/swww/$color_monitor"
        if [[ -f "$cache_file" ]]; then
            wallpaper_path=$(awk 'NF && $0 !~ /^filter/ {print; exit}' "$cache_file")
            if [[ -n "$wallpaper_path" && -f "$wallpaper_path" ]]; then
                echo "Generating colors from: $wallpaper_path"
                "$SCRIPTSDIR/WallustSwww.sh" "$wallpaper_path"
                "$SCRIPTSDIR/RefreshNoWaybar.sh"
            fi
        fi
    fi

    echo "Sleeping for $INTERVAL seconds..."
    sleep $INTERVAL
done