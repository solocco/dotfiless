#!/bin/bash
set -e
set -o pipefail

# ANSI colors
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"
BOLD="\033[1m"

USERNAME=$(logname)

banner() {
  echo -e "\n${CYAN}##################################################${RESET}"
  echo -e "${CYAN}#${RESET} ${BOLD}$1${RESET}"
  echo -e "${CYAN}##################################################${RESET}"
}

step() {
  echo -e "${GREEN}▶ $1${RESET}"
}

warn() {
  echo -e "${YELLOW}⚠️  $1${RESET}"
}

banner "Menyetel sudo agar grup 'wheel' tidak perlu password"
step "Mengatur file sudoers.d/wheel"
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" | sudo EDITOR='tee' visudo -f /etc/sudoers.d/wheel

banner "Memperbarui sistem"
sudo xbps-install -Suy

banner "Menginstal paket-paket yang dibutuhkan"
sudo xbps-install -Sy \
	xorg base-devel libX11-devel libXft-devel libXinerama-devel \
	polkit elogind polkit-gnome \
	NetworkManager NetworkManager-l2tp NetworkManager-openconnect NetworkManager-openvpn NetworkManager-pptp NetworkManager-strongswan NetworkManager-vpnc network-manager-applet \
	bluez blueman \
	gvfs gvfs-afc gvfs-afp gvfs-cdda gvfs-gphoto2 gvfs-mtp gvfs-smb udiskie udisks2 \
	ffmpegthumbnailer highlight trash-cli tumbler ueberzug xdg-user-dirs xdg-user-dirs-gtk thunar-archive-plugin thunar-media-tags-plugin thunar-volman \
	pipewire wireplumber pavucontrol alsa-pipewire alsa-plugins-jack alsa-plugins-pulseaudio \
	libde265 libmpeg2 libtheora libvpx x264 x265 xvidcore ffmpeg mesa-vaapi mesa-vdpau \
	jasper libwebp libavif libheif noto-fonts-ttf noto-fonts-emoji noto-fonts-ttf-extra \
	geany geany-plugins Thunar viewnior atril \
	htop ranger neovim \
	p7zip unzip xz xarchiver zip \
	qt5ct qt6ct \
	curl git inetutils wget \
	pulsemixer \
	wireless_tools ufetch \
	dunst picom rofi maim slop \
	acpi light \
	arandr bc gtk3-nocsd gtk-engine-murrine gnome-keyring inotify-tools jq meld nano \
	wmctrl wmname xclip xcolor xdotool yad \
	fribidi fribidi-devel glib-devel harfbuzz-devel gd-devel \
	lxappearance firefox pamixer bat lsd zsh

banner "Menyalin file konfigurasi ke direktori home"
DOTFILES_DIR="$HOME/dotfiless"
cp -rv "$DOTFILES_DIR"/{.config,.dwm,.icons,.local,.oh-my-zsh,.themes,suckless,.bashrc,.xinitrc,.zshrc,xresources} ~/

banner "Membangun program suckless (dwm, dmenu, st)"
SUCKLESS_DIR="$HOME/dotfiless/suckless"
for prog in dwm dmenu st; do
	PROG_PATH="$SUCKLESS_DIR/$prog"
	if [ -d "$PROG_PATH" ]; then
		banner "Building $prog"
		cd "$PROG_PATH"
		make
		sudo make clean install
	else
		warn "$PROG_PATH tidak ditemukan, dilewati."
	fi
done

banner "Membersihkan paket (orphan)"
sudo xbps-remove -Oy

banner "Menyusun ulang konfigurasi semua paket"
sudo xbps-reconfigure -fa

banner "Memperbarui cache font"
sudo fc-cache -fv && fc-cache -fv

banner "Mengaktifkan layanan penting (NetworkManager, dbus, bluetoothd, polkitd)"
sudo sv down dhcpcd

for svc in NetworkManager dbus bluetoothd polkitd; do
	step "🔗 Mengaktifkan $svc"
	sudo ln -sf /etc/sv/"$svc" /var/service/
done

banner "Menonaktifkan wpa_supplicant dan dhcpcd"
sudo rm -f /var/service/wpa_supplicant
sudo rm -f /var/service/dhcpcd

# Optional services (hapus komentar jika perlu)
# banner "Mengaktifkan libvirtd, virtlogd, seatd"
# sudo ln -s /etc/sv/libvirtd /var/service/
# sudo ln -s /etc/sv/virtlogd /var/service/
# sudo ln -s /etc/sv/seatd /var/service/
# sudo usermod -aG _seatd "$USERNAME"
# sudo usermod -aG libvirt "$USERNAME"
# sudo modprobe kvm-intel
# sudo usermod -aG kvm "$USERNAME"

banner "Mengupdate konfigurasi GRUB"
sudo grub-mkconfig -o /boot/grub/grub.cfg

banner "Mengubah shell default ke zsh untuk $USERNAME"
sudo chsh -s /usr/bin/zsh "$USERNAME"

banner "Semua konfigurasi selesai!"

read -rp "Apakah Anda ingin me-reboot sekarang? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
	banner "Me-reboot sistem..."
	sudo reboot
else
	echo -e "${BLUE}Reboot dibatalkan. Silakan reboot manual jika diperlukan.${RESET}"
fi
