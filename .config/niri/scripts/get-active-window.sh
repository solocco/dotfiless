#!/usr/bin/env bash

output=$(niri msg focused-window 2>/dev/null)

# Parse App ID dan Title
app=$(echo "$output" | grep 'App ID:' | sed 's/.*App ID: "\(.*\)"/\1/')
name=$(echo "$output" | grep 'Title:' | sed 's/.*Title: "\(.*\)"/\1/')

# Kalau tidak ada window aktif, tampilkan ikon Desktop
if [ -z "$app" ] || [ -z "$name" ]; then
  echo "󰋜 Desktop"
  exit 0
fi

# Kapitalisasi app
app=$(echo "$app" | sed 's/.*/\u&/')

# Icon mapping
case "$app" in
  Firefox) icon=" " ;;
  Brave|Brave-browser) icon=" " ;;
  Chromium|Chrome) icon=" " ;;
  Alacritty|Foot|Kitty|Wezterm|Termite) icon=" " ;;
  Code|Codium) icon=" " ;;
  Nvim|Neovim) icon=" " ;;
  Thunar|Nautilus|Pcmanfm) icon=" " ;;
  Mpv|Vlc) icon=" " ;;
  *) icon=" " ;;
esac

# Output final
printf "%s%s: %s\n" "$icon" "$app" "$name"
