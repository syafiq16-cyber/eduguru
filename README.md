# 🎓 EduGuru - Asisten Guru Modern

<div align="center">

![EduGuru Logo](public/favicon.svg)

**Aplikasi manajemen guru terintegrasi dengan AI untuk mengelola jurnal mengajar, absensi siswa, penilaian, dan bimbingan konseling.**

[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js&logoColor=white)](https://nodejs.org/)
[![React](https://img.shields.io/badge/React-19-61DAFB?logo=react&logoColor=white)](https://react.dev/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-4169E1?logo=postgresql&logoColor=white)](https://postgresql.org/)
[![Gemini AI](https://img.shields.io/badge/Gemini-AI-8E75B2?logo=google&logoColor=white)](https://ai.google.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[Demo](#) • [Dokumentasi](#fitur) • [Instalasi](#instalasi) • [Deployment](DEPLOYMENT.md)

</div>

---

## ✨ Fitur

### 📚 Jurnal Mengajar
- Catat aktivitas harian mengajar secara digital
- Generate refleksi otomatis dengan AI
- Export ke PDF dengan format profesional
- Statistik dan laporan bulanan

### 📋 Absensi Siswa
- Input absensi dengan interface yang intuitif
- Status: Hadir, Sakit, Izin, Alpha
- Rekap absensi per kelas/periode
- Export data ke Excel/PDF

### 📊 Penilaian
- Input nilai formatif dan sumatif
- Kalkulasi otomatis (rata-rata, predikat)
- Bobot nilai yang dapat dikustomisasi
- Rekap nilai siswa lengkap

### 💬 Bimbingan Konseling
- Dokumentasi sesi konseling
- Generate saran tindak lanjut dengan AI
- Kategorisasi masalah (akademik, perilaku, pribadi)
- Riwayat bimbingan per siswa

### 🤖 Asisten AI (Gemini)
- Chat interaktif untuk bantuan mengajar
- Generate soal latihan
- Saran metode pembelajaran
- Rangkuman materi

### 📱 Fitur Lainnya
- Dark/Light mode
- Responsive (mobile-friendly)
- Multi-user dengan autentikasi
- Export data (PDF, Excel)

---

## 🛠️ Tech Stack

| Layer | Teknologi |
|-------|-----------|
| **Frontend** | React 19, TypeScript, Tailwind CSS |
| **Backend** | Node.js, Express.js |
| **Database** | PostgreSQL |
| **AI** | Google Gemini 1.5 Flash |
| **Auth** | JWT, bcrypt |
| **Build** | Vite |

---

## 📦 Instalasi

### Prasyarat

- Node.js 18.x atau lebih baru
- PostgreSQL 14.x atau lebih baru
- Gemini API Key ([dapatkan di sini](https://aistudio.google.com/apikey))

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/eduguru.git
cd eduguru
```

### 2. Install Dependencies

```bash
# Install frontend dependencies
npm install

# Install backend dependencies (jika terpisah)
npm install express cors pg dotenv bcryptjs jsonwebtoken @google/generative-ai
```

### 3. Konfigurasi Environment

```bash
cp .env.example .env
```

Edit file `.env`:

```env
# Server
PORT=3001
NODE_ENV=development
JWT_SECRET=your-secret-key

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=eduguru
DB_USER=postgres
DB_PASSWORD=your_password

# Gemini AI
GEMINI_API_KEY=your_gemini_api_key
```

### 4. Setup Database

```bash
# Buat database
createdb eduguru

# Schema akan dibuat otomatis saat server dijalankan
# Atau jalankan manual:
psql -U postgres -d eduguru -f schema.sql
```

### 5. Jalankan Aplikasi

**Development:**
```bash
# Terminal 1: Frontend
npm run dev

# Terminal 2: Backend
npm run dev:server

# Atau keduanya sekaligus:
npm run dev:full
```

**Production:**
```bash
# Build frontend
npm run build

# Jalankan server
npm start
```

### 👤 Akun Demo (Uji Coba Cepat)
Aplikasi menyediakan akun demo bawaan sehingga Anda dapat langsung masuk tanpa perlu registrasi:
- **Metode 1**: Klik tombol **"Masuk Demo (1-Klik)"** di halaman login.
- **Metode 2**: Masuk manual dengan kredensial:
  - **Username / Email**: `demo@eduguru.id` (atau cukup ketik `demo`)
  - **Password**: `demo123`
  - *Data sampel seperti kelas, siswa, jurnal mengajar, dan absensi sudah tersedia secara otomatis.*

---

## 🔧 Konfigurasi

### Environment Variables

| Variable | Deskripsi | Default |
|----------|-----------|---------|
| `PORT` | Port untuk backend server | `3001` |
| `NODE_ENV` | Environment mode | `development` |
| `JWT_SECRET` | Secret key untuk JWT | - |
| `DATABASE_URL` | PostgreSQL connection string | - |
| `DB_HOST` | Database host | `localhost` |
| `DB_PORT` | Database port | `5432` |
| `DB_NAME` | Database name | `eduguru` |
| `DB_USER` | Database user | - |
| `DB_PASSWORD` | Database password | - |
| `GEMINI_API_KEY` | Google Gemini API Key | - |
| `CORS_ORIGIN` | Allowed CORS origin | `*` |

---

## 🚀 Deployment

Lihat [DEPLOYMENT.md](DEPLOYMENT.md) untuk panduan lengkap deployment ke VPS dengan aaPanel.

### Quick Deploy

```bash
# Build production
npm run build

# Start with PM2
pm2 start ecosystem.config.js --env production
```

---

## 📁 Struktur Proyek

```
eduguru/
├── components/          # React components
│   ├── Login.tsx
│   ├── Dashboard.tsx
│   ├── Journal.tsx
│   ├── Attendance.tsx
│   ├── Assessment.tsx
│   ├── Counseling.tsx
│   ├── ChatAI.tsx
│   └── ...
├── services/            # Business logic & API
│   ├── apiService.ts    # Backend API client
│   ├── geminiService.ts # AI service wrapper
│   ├── storageService.ts# Data management
│   └── exportService.ts # PDF/Excel export
├── public/              # Static assets
├── server.js            # Express backend
├── App.tsx              # Main React app
├── types.ts             # TypeScript types
├── constants.ts         # App constants
├── vite.config.ts       # Vite configuration
├── ecosystem.config.js  # PM2 configuration
├── schema.sql           # Database schema
├── nginx.conf           # Nginx configuration
└── DEPLOYMENT.md        # Deployment guide
```

---

## 🔒 Keamanan

- Password di-hash dengan bcrypt
- Autentikasi menggunakan JWT
- API Key Gemini disimpan di server (tidak di client)
- CORS dikonfigurasi untuk production
- Input validation di backend

---

## 📝 API Endpoints

### Auth
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/auth/register` | Registrasi user baru |
| POST | `/api/auth/login` | Login user |
| GET | `/api/auth/me` | Get current user |
| PUT | `/api/auth/me` | Update profile |

### Data
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/classes` | Get all classes |
| GET | `/api/students` | Get all students |
| GET | `/api/journals` | Get all journals |
| GET | `/api/attendance` | Get attendance records |
| GET | `/api/scores` | Get scores |
| GET | `/api/counseling` | Get counseling sessions |

### AI
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/ai/reflection` | Generate reflection |
| POST | `/api/ai/teaching-methods` | Suggest methods |
| POST | `/api/ai/follow-up` | Generate follow-up plan |
| POST | `/api/ai/chat` | Chat with AI |

---

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan:

1. Fork repository
2. Buat branch baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

---

## 📄 Lisensi

Didistribusikan di bawah Lisensi MIT. Lihat `LICENSE` untuk informasi lebih lanjut.

---

## 👏 Credits

- [React](https://react.dev/) - UI Library
- [Vite](https://vitejs.dev/) - Build Tool
- [Tailwind CSS](https://tailwindcss.com/) - CSS Framework
- [Lucide Icons](https://lucide.dev/) - Icon Library
- [Google Gemini](https://ai.google.dev/) - AI Model
- [jsPDF](https://github.com/parallax/jsPDF) - PDF Generation
- [SheetJS](https://sheetjs.com/) - Excel Processing

---

<div align="center">

**Made with ❤️ for Indonesian Teachers**

[⬆ Kembali ke atas](#-eduguru---asisten-guru-modern)

</div>
