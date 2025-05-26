#!/bin/bash
set -e  # Exit on any error
set -o pipefail

USERNAME=$(logname)

# Allow wheel group passwordless sudo
sudo sed -i 's/^%wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers.d/wheel

# System update
sudo xbps-install -Suy

# Install packages
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
		  
	
cp -r .config .dwm .icons .local .oh-my-zsh .themes suckless .bashrc .xinitrc .zshrc xresources ~/

# Build suckless programs
SUCKLESS_DIR="$HOME/dotfiless/suckless"

for prog in dwm dmenu st; do
	PROG_PATH="$SUCKLESS_DIR/$prog"
	if [ -d "$PROG_PATH" ]; then
		echo "Building $prog..."
		cd "$PROG_PATH"
		make
		sudo make clean install
	else
		echo "Warning: $PROG_PATH does not exist, skipping."
	fi
done

# Clean up orphan packages
sudo xbps-remove -Oy
sudo xbps-remove -oy

# Reconfigure all packages
sudo xbps-reconfigure -fa

# Update font cache
sudo fc-cache && fc-cache

# Switch to NetworkManager
sudo sv down dhcpcd
sudo ln -sf /etc/sv/NetworkManager /var/service/
sudo ln -sf /etc/sv/dbus /var/service/
sudo ln -sf /etc/sv/bluetoothd /var/service/
sudo ln -sf /etc/sv/polkitd /var/service/

# Optional service links (uncomment if needed)
# sudo ln -s /etc/sv/libvirtd /var/service/
# sudo ln -s /etc/sv/virtlogd /var/service/
# sudo ln -s /etc/sv/seatd /var/service/
# sudo usermod -aG _seatd "$USERNAME"
# sudo usermod -aG libvirt "$USERNAME"
# sudo modprobe kvm-intel  # Use 'kvm-amd' for AMD CPUs
# sudo usermod -aG kvm "$USERNAME"

sudo rm -f /var/service/wpa_supplicant
sudo rm -f /var/service/dhcpcd

# GRUB and auto-login config
#sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
#sudo sed -i "s/GETTY_ARGS=\"--noclear\"/GETTY_ARGS=\"--noclear --autologin $USERNAME\"/" \
#	/etc/runit/runsvdir/current/agetty-tty1/conf

# Update GRUB config
sudo grub-mkconfig -o /boot/grub/grub.cfg

#update dir
xdg-user-dirs-update

# change bash to zsh
sudo chsh -s /usr/bin/zsh
#sudo chsh -s /usr/bin/zsh "$USERNAME"

# Reboot system
sudo reboot
