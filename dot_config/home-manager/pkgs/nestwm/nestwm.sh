#!/bin/sh
# Run labwc nested in the current Wayland session with a translucent background.
# Usage: nestwm [command...]
#   NESTWM_BG=#RRGGBBAA  background tint (default: #1e1e2e33)
#   NESTWM_DEBUG=1       verbose log on stderr
#   NESTWM_X11_SCALE=N   scale X11 apps render at (default: 2, for GDK_SCALE=2);
#                        "output" follows the output scale instead
set -eu

export WLR_SCENE_CLEAR_COLOR="${NESTWM_BG:-#1e1e2e33}"
# Only for labwc itself, not for the apps inside
export LABWC_UNSET_AFTER_INIT=WLR_SCENE_CLEAR_COLOR

# For config/autostart -> clipsync
export NESTWM_DIR=@share@
export NESTWM_HOST_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"

# X11 apps render at full resolution instead of being upscaled (like
# Hyprland's xwayland:force_zero_scaling), at NESTWM_X11_SCALE times the
# logical size and shown resized to the output scale
export LABWC_XWAYLAND_ZERO_SCALING=1
x11_scale="${NESTWM_X11_SCALE:-2}"
if [ "$x11_scale" != output ]; then
	export LABWC_XWAYLAND_SCALE="$x11_scale"
fi

# lab-sensible-terminal, wl-clipboard for clipsync
export PATH="@path@:$PATH"

[ $# -gt 0 ] && set -- -s "$*"
# Full labwc/wlroots logging on stderr
[ -n "${NESTWM_DEBUG:-}" ] && set -- -d "$@"

exec labwc -C "$NESTWM_DIR/config" -t nestwm "$@"
