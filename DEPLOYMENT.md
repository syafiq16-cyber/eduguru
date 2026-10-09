# 🎓 EduGuru - Panduan Lengkap Deployment aaPanel

Panduan langkah-demi-langkah mendeploy EduGuru di VPS (Ubuntu/Debian/CentOS) menggunakan **aaPanel**.

---

## 📋 Daftar Isi

1. [Persyaratan Sistem & Software](#-persyaratan-sistem)
2. [Setup Database PostgreSQL di aaPanel](#-setup-database-postgresql)
3. [Upload Kode ke Server](#-upload-kode)
4. [Deployment Cepat (1-Perintah via deploy.sh)](#-metode-1-deployment-cepat-rekomendasi)
5. [Konfigurasi Domain & Nginx di aaPanel](#-konfigurasi-domain--nginx-di-aapanel)
6. [Konfigurasi Gemini AI (Opsional)](#-konfigurasi-gemini-ai)
7. [Akun Demo Bawaan](#-akun-demo-bawaan)
8. [Maintenance & Perintah Berguna](#-maintenance--perintah-berguna)
9. [Troubleshooting](#-troubleshooting)

---

## 🖥️ Persyaratan Sistem

### Minimum Requirements:
- **OS**: Ubuntu 20.04/22.04 LTS, Debian 11/12, atau AlmaLinux/CentOS
- **RAM**: Minimal 1 GB (Direkomendasikan 2 GB)
- **Disk**: Minimal 10 GB SSD

### Software yang Perlu Diinstall via aaPanel App Store:
1. **Nginx** (Web Server)
2. **PostgreSQL Manager** atau PostgreSQL (v14 ke atas)
3. **Node.js Manager** (Pilih Node.js versi 18 LTS atau 20 LTS)
4. **PM2 Manager** (atau install via CLI: `npm install -g pm2`)

---

## 🗄️ Setup Database PostgreSQL

1. Masuk ke **aaPanel** → Menu **Database** → Tab **PostgreSQL**.
2. Klik tombol **Add Database**:
   - **DB Name**: `eduguru` (atau `dbeduguru`)
   - **DB User**: `eduguru_user` (atau sesuai keinginan)
   - **Password**: Buat password yang kuat dan simpan
   - **Access Permission**: `Local` / `127.0.0.1`
3. Catat nama database, username, dan password ini untuk diisi ke `.env`.

> 💡 *Catatan: Tabel database dan akun demo akan dibuat otomatis oleh server saat pertama kali dijalankan. Jika ingin inisialisasi manual, jalankan `psql -U eduguru_user -d eduguru -f schema.sql`.*

---

## 📂 Upload Kode

### Cara A: Melalui Git (Direkomendasikan)
Masuk via SSH terminal VPS:
```bash
cd /www/wwwroot
git clone https://github.com/username/eduguru.git
cd eduguru
```

### Cara B: Melalui File Manager aaPanel
1. Buka menu **Files** di aaPanel.
2. Masuk ke folder `/www/wwwroot/`.
3. Buat folder `eduguru` dan upload seluruh file proyek ke folder tersebut.

---

## 🚀 Metode 1: Deployment Cepat (Rekomendasi)

Proyek ini telah dilengkapi dengan skrip otomatis `deploy.sh`. Skrip ini otomatis:
- Menginstall dependensi root, frontend, dan backend
- Memperbaiki izin file binary Linux VPS
- Mem-build frontend ke folder `dist`
- Menjalankan backend di port `3002` menggunakan PM2
- Memeriksa health endpoint

### 1. Buat & Sesuaikan File `.env`
Salin template konfigurasi:
```bash
cd /www/wwwroot/eduguru
cp .env.example backend/.env
```
Edit konfigurasi backend:
```bash
nano backend/.env
```
Sesuaikan parameter database:
```env
PORT=3002
NODE_ENV=production

JWT_SECRET=buat_string_acak_panjang_minimal_32_karakter

DB_HOST=localhost
DB_PORT=5432
DB_NAME=eduguru
DB_USER=eduguru_user
DB_PASSWORD=password_database_anda
DB_SSL=false

# Opsional: Dapatkan API Key di https://aistudio.google.com/apikey
GEMINI_API_KEY=
```
*(Tekan `CTRL+O` lalu `ENTER` untuk simpan, `CTRL+X` untuk keluar dari nano).*

### 2. Jalankan Script Deployment
```bash
chmod +x deploy.sh
./deploy.sh
```

Aplikasi Anda kini telah aktif di port `3002`!

---

## 🌐 Konfigurasi Domain & Nginx di aaPanel

Setelah aplikasi berjalan di port `3002`, arahkan domain Anda ke server.

### Langkah 1: Tambahkan Website di aaPanel
1. Masuk ke **aaPanel** → **Website** → **Add Site**.
2. **Domain**: Masukkan nama domain Anda (contoh: `eduguru.domain.com`).
3. **Database**: Tidak perlu centang (sudah dibuat terpisah).
4. **PHP Version**: Pilih `Pure Static`.
5. Klik **Submit**.

### Langkah 2: Setup Reverse Proxy (Paling Mudah & Anti Gagal)
1. Pada daftar Website, klik **nama domain Anda**.
2. Pilih menu **Reverse Proxy** di bilah kiri → Klik **Add Reverse Proxy**.
3. Isi parameter:
   - **Proxy Name**: `eduguru`
   - **Target URL**: `http://127.0.0.1:3002`
   - **Sent Domain**: `$host`
4. Centang **Enable Proxy** dan klik **Save**.

### Atau Langkah Alternatif (Custom Nginx Conf):
Jika ingin static caching tingkat lanjut, buka tab **Config** (atau **Nginx Conf**), dan salin seluruh isi file [`nginx.conf`](file:///Users/ahmad/Documents/Coding/PROJECT%20ANTIGRAVITY/eduguru/nginx.conf) ke konfigurasi Nginx situs Anda.

### Langkah 3: Pasang SSL (HTTPS Gratis)
1. Di jendela konfigurasi domain yang sama, pilih tab **SSL**.
2. Pilih **Let's Encrypt**.
3. Centang domain Anda dan klik **Apply**.
4. Setelah terbit, aktifkan sakelar **Force HTTPS**.

---

## 🤖 Konfigurasi Gemini AI

Fitur asisten AI (pembuat soal, pembuat refleksi jurnal otomatis) menggunakan Google Gemini AI:
1. Dapatkan API Key gratis di [Google AI Studio](https://aistudio.google.com/apikey).
2. Buka `backend/.env` di server:
   ```env
   GEMINI_API_KEY=AIzaSy...
   ```
3. Muat ulang aplikasi:
   ```bash
   pm2 reload eduguru --update-env
   ```

---

## 👤 Akun Demo Bawaan

Server otomatis membuat akun demo saat pertama kali diinisialisasi sehingga Anda dan penguji dapat langsung login:
- **Tombol Cepat**: Klik **"Masuk Demo (1-Klik)"** pada halaman login.
- **Username / Email**: `demo@eduguru.id` *(atau cukup ketik `demo`)*
- **Password**: `demo123`
- **Data Siap Pakai**: 2 Kelas sampel, 10 Siswa, Jurnal Mengajar, dan Absensi otomatis terisi.

---

## 📊 Maintenance & Perintah Berguna

Semua perintah dijalankan di dalam folder `/www/wwwroot/eduguru`:

| Aksi | Perintah |
| :--- | :--- |
| **Cek Status Server** | `pm2 status` |
| **Lihat Log Realtime** | `pm2 logs eduguru` |
| **Restart Aplikasi** | `pm2 restart eduguru` |
| **Stop Aplikasi** | `pm2 stop eduguru` |
| **Deploy / Update Baru** | `git pull && ./deploy.sh` |
| **Cek Koneksi API** | `curl http://127.0.0.1:3002/api/health` |

---

## ❓ Troubleshooting

### 1. Pesan "502 Bad Gateway"
- **Penyebab**: Node.js backend belum berjalan di port `3002`.
- **Solusi**:
  ```bash
  pm2 status
  pm2 logs eduguru --lines 50
  ```
  Pastikan database PostgreSQL sedang berjalan dan kredensial di `backend/.env` sudah benar.

### 2. Database Connection Error (ECONNREFUSED / password auth failed)
- Pastikan service PostgreSQL aktif:
  ```bash
  systemctl status postgresql
  ```
- Cek file `backend/.env`: pastikan `DB_USER`, `DB_PASSWORD`, dan `DB_NAME` cocok dengan database yang dibuat di aaPanel.

### 3. Port 3002 Konflik / Sudah Digunakan
- Periksa proses apa yang memakai port 3002:
  ```bash
  lsof -i :3002
  ```
- Jika ada proses lama, hentikan dengan `kill -9 <PID>` atau ganti nilai `PORT=3003` di `backend/.env` dan sesuaikan Target URL Reverse Proxy Nginx.

---

**Selamat! EduGuru kini siap melayani guru-guru dengan performa optimal di aaPanel! 🎓🚀**
