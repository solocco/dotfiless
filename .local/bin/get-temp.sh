#!/usr/bin/env bash

for hwmon in /sys/class/hwmon/hwmon*; do
    name=$(cat "$hwmon/name" 2>/dev/null)
    if [[ "$name" == "k10temp" || "$name" == "coretemp" || "$name" == "zenpower" ]]; then
        for temp in "$hwmon"/temp*_input; do
            if [[ -r "$temp" ]]; then
                val=$(cat "$temp")
                if [[ "$val" -ge 10000 && "$val" -le 110000 ]]; then
                    printf "%d°C\n" "$((val / 1000))"
                    exit 0
                fi
            fi
        done
    fi
done

echo "N/A"
