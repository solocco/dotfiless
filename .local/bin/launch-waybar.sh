#!/usr/bin/env bash
set -euo pipefail

pkill -x waybar 2>/dev/null || true
sleep 0.3

# Deteksi window manager yang aktif
if pgrep -x sway >/dev/null; then
  CURRENT_WM="sway"
elif pgrep -x niri >/dev/null; then
  CURRENT_WM="niri"
elif pgrep -x river >/dev/null; then
  CURRENT_WM="river"
elif pgrep -x maomao >/dev/null; then
  CURRENT_WM="maomao"
elif pgrep -x labwc >/dev/null; then
  CURRENT_WM="labwc"
else
  CURRENT_WM="sway"
fi

echo "CURRENT_WM=$CURRENT_WM" >> /tmp/waybar-launch.log

CONFIG_FILE="$HOME/.config/waybar/config-$CURRENT_WM"
STYLE_FILE="$HOME/.config/waybar/style-$CURRENT_WM.css"

if [[ -f "$CONFIG_FILE" && -f "$STYLE_FILE" ]]; then
  echo "✔ Menjalankan waybar dengan config: $CURRENT_WM" >> /tmp/waybar-launch.log
  waybar -c "$CONFIG_FILE" -s "$STYLE_FILE" &
else
  echo "❌ Config atau style untuk '$CURRENT_WM' tidak ditemukan!" >> /tmp/waybar-launch.log
  echo "→ Dicari: $CONFIG_FILE dan $STYLE_FILE" >> /tmp/waybar-launch.log
  exit 1
fi
