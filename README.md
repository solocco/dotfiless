# 🐧 Void Linux + DWM Setup (Otomatis)

Konfigurasi otomatis untuk Void Linux + DWM menggunakan skrip shell. Dirancang agar ringan, cepat, dan rapi tanpa display manager. Cocok untuk pengguna yang ingin sistem minimalis namun fungsional.

---

## 🛠️ Fitur Utama

| Komponen       | Detail                      |
|----------------|-----------------------------|
| Linux          | Void Linux (glibc)          |
| WM             | DWM                         |
| Terminal       | St                          |
| App Launcher   | Dmenu                       |
| Font           | Jetbrains Mono Nerd Fonts   |
| Theme          | Gruvbox Dark                |
| Icon           | Gruvbox Dark                |
| Shell          | zsh                         |
| Compositor     | picom                       |
| Notification   | dunst                       |

---

## 🚀 Cara Instalasi

### 1. Clone repo

```bash
git clone https://github.com/solocco/dotfiless.git
cd dotfiless
```

---

### 2. Jalankan skrip utama

```bash
chmod +x VoidLinux.sh
./VoidLinux.sh
```

> Atau gunakan alternatif:
>
> ```bash
> chmod +x voidlinux2.sh
> ./voidlinux2.sh
> ```

---

## 🗂️ Struktur Folder

Pastikan struktur `dotfiless` Anda berada di `$HOME/dotfiless` dan memiliki direktori berikut:

```text
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
```

---

## ⚙️ Setelah Instalasi

* Reboot untuk memulai session dengan DWM dan konfigurasi lengkap.
* Gunakan `startx` untuk login ke DWM jika belum otomatis.

---

## 💡 Catatan

* Pastikan koneksi internet aktif saat menjalankan.

---

## 📄 Lisensi

MIT / GPL-3.0 — silakan modifikasi dan gunakan kembali sesuai kebutuhan.

---

## 👤 Penulis

* [@solocco](https://github.com/solocco)
