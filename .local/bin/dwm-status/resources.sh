#!/usr/bin/dash

base="#191724"
text="#e0def4"
gold="#f6c177"
rose="#ebbcba"
muted="#6e6a86"
subtle="#908caa"
reset="^d^"

kernel() {
  stat=$(uname -r | rev | cut -b3- | rev | cut -b1-)
  printf " $stat "
}

mem() {
  memused=$(free -h --giga | grep Mem | awk '{print $3}')
  printf "$reset ^b$gold^^c$base^ $memused ^b$subtle^^c$base^  $reset"
}
cpu_use() {
  cpuused=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')
  printf "$reset ^b$gold^^c$base^ $cpuused%% ^b$subtle^^c$base^  "
}

temp_cpu() {
  crit=70
  tmp=$(sensors | grep 'Package id 0' | awk '{print int($4)}' | tr -d '+°C')

  if [ "$tmp" -lt "$crit" ]; then
    printf "$reset ^b$text^^c$base^ $tmp° ^b$subtle^^c$base^ 󰜗 $reset"
  else
    printf "$reset ^b$rose^^c$base^ $tmp° ^b$subtle^^c$base^ 󱩱 $reset"
  fi
}

vol() {
  vol=$(pw-vol status | awk '{print $1}' | rev | cut -b2- | rev | cut -b15-)
  stat_mute=$(pw-vol status | awk '{print $1}' | rev | cut -b3- | rev | cut -b9-)
  stat_headphone=$(amixer -c 0 cget numid=14,iface=CARD | awk -F"=" 'NR == 3 {print $2;}')
  stat_bt_headphone=$(bluetoothctl info | grep Paired | awk '{print $2}')
  bat_bt=$(bluetoothctl info | grep Battery | awk '{print $4}' | sed 's/[()]//g')
  if [ "$stat_mute" = "mute" ]; then
    printf "$reset ^b$muted^^c$base^ mute ^b$subtle^^c$base^ 󰝟 $reset"
  elif [ "$stat_bt_headphone" = "yes" ]; then
    printf " $vol|$bat_bt  󰂱 "
  elif [ "$stat_headphone" = "on" ]; then
    printf "$reset ^b$text^^c$base^ $vol ^b$subtle^^c$base^  $reset"
  else
    printf "$reset ^b$text^^c$base^ $vol ^b$subtle^^c$base^ 󰜟 $reset"
  fi
}

light() {
  printf "󰹑 $(xbacklight -get)"
}

bat() {
  prec=$(cat /sys/class/power_supply/BAT0/capacity)
  stat=$(cat /sys/class/power_supply/BAT0/status)

  if [ "$stat" = "Charging" ]; then
    printf "^b$rose^^c$base^ $prec ^b$subtle^^c$base^ 󱊦 $reset"
  else
    printf "^b$rose^^c$base^ $prec ^b$subtle^^c$base^ 󱊣 $reset"
  fi
}

clock() {
  printf "$(date '+%R ') "
}

connection() {
  status=$(wpa_cli status | sed -n '/wpa_state/s/^.*=//p')

  case $status in
  'COMPLETED')
    printf " Connected 󱚽 "
    ;;
  'INTERFACE_DISABLED')
    printf " 󱚼 "
    ;;
  'SCANNING')
    printf " 󱛁 "
    ;;
  'AUTHENTICATING')
    printf " 󱚾"
    ;;
  esac
}

playing() {
  mpd_info=$(ncmpcpp --current-song "%a - %t" 2>/dev/null)
  
  if [ -n "$mpd_info" ] && ! echo "$mpd_info" | grep -q "Reading configuration from"; then
    title="$mpd_info"
  else
    title=$(playerctl metadata title 2>&1)
    status=$(playerctl status 2>&1)

    if [ "$status" = "Paused" ]; then
      status=" 󱫝"
    else
      status=""
    fi

    if [ "$title" = "Ankama Launcher" ]; then
      printf "... 󰫔"
      return
    elif [ "$title" = "No players found" ]; then
      printf "... 󰫔"
      return
    fi
  fi

  # Potong judul jika terlalu panjang
  length=${#title}
  if [ $length -gt 30 ]; then
    short_title=$(echo "$title" | cut -c1-30)
    short_title="${short_title}..."
    printf "$status %s 󰫔" "$short_title"
  else
    printf "$status %s 󰫔" "$title"
  fi
}

playing
cpu_use
mem
vol
# light
connection
clock
bat
temp_cpu
