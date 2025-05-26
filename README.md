🐧 Void Linux + DWM Setup (Otomatis)

Konfigurasi otomatis untuk Void Linux + DWM menggunakan skrip shell. Dirancang agar ringan, cepat, dan rapi tanpa display manager. Cocok untuk pengguna yang ingin sistem minimalis namun fungsional.

🛠️ Fitur Utama

✅ Void Linux Base Setup

✅ dwm, st, dmenu (build dari suckless)

✅ Konfigurasi dotfiles otomatis

✅ NetworkManager, bluetooth, pipewire, polkit

✅ Rofi, picom, dunst, ZSH + Oh-My-Zsh

✅ Setup font, tema, dan tools penting lainnya

✅ Shell interaktif & prompt reboot

🚀 Cara Instalasi

1. Clone repo

git clone https://codeberg.org/solocco/dotfiless.git
cd dotfiless

2. Jalankan skrip utama

chmod +x VoidLinux.sh
./VoidLinux.sh

Atau gunakan alternatif:

chmod +x voidlinux2.sh
./voidlinux2.sh

🗂️ Struktur Folder

Pastikan struktur dotfiless Anda berada di $HOME/dotfiless dan memiliki direktori berikut:

dotfiless/
├── .config/
├── .dwm/
├── .icons/
├── .local/
├── .oh-my-zsh/
├── .themes/
├── suckless/
│   ├── dwm/
│   ├── st/
│   └── dmenu/
├── .bashrc
├── .xinitrc
├── .zshrc
└── xresources

⚙️ Setelah Instalasi

Reboot untuk memulai session dengan DWM dan konfigurasi lengkap.

Gunakan startx untuk login ke DWM jika belum otomatis.

💡 Catatan

Skrip akan menghapus layanan dhcpcd & wpa_supplicant dan menggantinya dengan NetworkManager.

Anda bisa aktifkan service tambahan seperti libvirtd, seatd dengan mengedit skrip.

Pastikan koneksi internet aktif saat menjalankan.

📄 Lisensi

MIT / GPL-3.0 — silakan modifikasi dan gunakan kembali sesuai kebutuhan.

👤 Penulis

@solocco


