#!/usr/bin/env bash

# Brightness control script for Wayland + mako (Gruvbox style)

set -euo pipefail

ICON_DIR="$HOME/.config/mako/icons"
NOTIFY_ID="sys-notify-brightness"

# Ambil brightness sekarang (dalam persen bulat)
get_backlight() {
    light_val=$(light -G 2>/dev/null || echo "0")
    printf "%.0f\n" "$light_val"
}

# Tentukan icon berdasarkan level brightness
get_icon() {
    local brightness="$1"
    if (( brightness <= 20 )); then
        icon="$ICON_DIR/brightness-20.png"
    elif (( brightness <= 40 )); then
        icon="$ICON_DIR/brightness-40.png"
    elif (( brightness <= 60 )); then
        icon="$ICON_DIR/brightness-60.png"
    elif (( brightness <= 80 )); then
        icon="$ICON_DIR/brightness-80.png"
    else
        icon="$ICON_DIR/brightness-100.png"
    fi
    [[ -f "$icon" ]] || icon="display-brightness"  # fallback icon
}

# Kirim notifikasi ke mako
notify_user() {
    local brightness="$1"
    get_icon "$brightness"

    # Hapus notifikasi lama agar tidak numpuk
    makoctl dismiss --group "$NOTIFY_ID" 2>/dev/null || true

    # Kirim notifikasi baru
    notify-send \
        -h string:x-canonical-private-synchronous:"$NOTIFY_ID" \
        -h string:group:"$NOTIFY_ID" \
        -u low \
        -i "$icon" \
        "Brightness : ${brightness}%"
}

# Naikkan brightness
inc_backlight() {
    light -A 5 && brightness=$(get_backlight) && notify_user "$brightness"
}

# Turunkan brightness
dec_backlight() {
    light -U 5 && brightness=$(get_backlight) && notify_user "$brightness"
}

# Eksekusi sesuai argumen
case "${1:-}" in
    --get)
        get_backlight
        ;;
    --inc)
        inc_backlight
        ;;
    --dec)
        dec_backlight
        ;;
    *)
        get_backlight
        ;;
esac
