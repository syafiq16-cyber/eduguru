#!/bin/bash
set -e

# ==============================================================================
# EduGuru Deployment Script for aaPanel / VPS
# ==============================================================================
# Usage:
#   chmod +x deploy.sh
#   ./deploy.sh
# ==============================================================================

ENV=${1:-production}
echo "============================================================"
echo "🚀 Memulai Deployment EduGuru (Mode: $ENV)"
echo "============================================================"

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

# 1. Cek Node.js & npm
echo "🔍 Memeriksa dependensi sistem..."
if ! command -v node &> /dev/null; then
  echo "❌ Node.js belum terinstall! Silakan install Node.js 18+ via aaPanel Node.js Manager."
  exit 1
fi
echo "  ✓ Node.js: $(node -v)"
echo "  ✓ NPM: $(npm -v)"

# 2. Setup File Konfigurasi .env jika belum ada
if [ ! -f "backend/.env" ] && [ -f "backend/.env.example" ]; then
  echo "📝 Membuat backend/.env dari backend/.env.example..."
  cp backend/.env.example backend/.env
fi

if [ ! -f ".env" ] && [ -f ".env.example" ]; then
  echo "📝 Membuat .env dari .env.example..."
  cp .env.example .env
fi

if [ ! -f "frontend/.env" ] && [ -f "frontend/.env.example" ]; then
  echo "📝 Membuat frontend/.env..."
  cp frontend/.env.example frontend/.env
fi

# 3. Install Dependensi (Root, Frontend, Backend)
echo "📚 Menginstall dependencies proyek..."
npm install
npm install --prefix frontend
npm install --prefix backend

# 4. Perbaiki Permissions (Khusus lingkungan Linux VPS)
echo "🔧 Memeriksa permission binary..."
if [ -d "frontend/node_modules/.bin" ]; then
  chmod +x frontend/node_modules/.bin/* 2>/dev/null || true
fi
if [ -d "node_modules/.bin" ]; then
  chmod +x node_modules/.bin/* 2>/dev/null || true
fi

# 5. Build Frontend
echo "🏗️  Membangun (build) frontend untuk production..."
npm run build

# 6. Validasi Hasil Build
if [ ! -f "frontend/dist/index.html" ] && [ ! -f "dist/index.html" ]; then
  echo "❌ Build frontend gagal! index.html tidak ditemukan."
  exit 1
fi
echo "  ✓ Build frontend selesai (dist/ ready)."

# 7. Kelola Proses dengan PM2
echo "🔄 Mengelola proses server dengan PM2..."
PM2_CMD="pm2"
if ! command -v pm2 &> /dev/null; then
  if npx pm2 -v &> /dev/null; then
    PM2_CMD="npx pm2"
  else
    echo "⚠️  PM2 belum terinstall secara global. Menginstall pm2..."
    npm install -g pm2 || true
    if ! command -v pm2 &> /dev/null; then
      PM2_CMD="npx pm2"
    fi
  fi
fi

if $PM2_CMD describe eduguru &> /dev/null; then
  echo "  ✓ Memuat ulang (reload) proses 'eduguru'..."
  $PM2_CMD reload ecosystem.config.cjs --update-env
else
  echo "  ✓ Menjalankan aplikasi via ecosystem.config.cjs..."
  $PM2_CMD start ecosystem.config.cjs
fi

$PM2_CMD save 2>/dev/null || true

# 8. Verifikasi Health Endpoint
echo "🏥 Memeriksa status kesehatan server..."
sleep 2
HEALTH_PORT=$(grep -E '^PORT=' backend/.env 2>/dev/null | cut -d '=' -f2 || echo "3002")
HEALTH_PORT=${HEALTH_PORT:-3002}

if command -v curl &> /dev/null; then
  if curl -s "http://127.0.0.1:${HEALTH_PORT}/api/health" | grep -q "ok"; then
    echo "  ✓ Backend berjalan dengan baik di port ${HEALTH_PORT}!"
  else
    echo "  ⚠️ Server belum merespons di port ${HEALTH_PORT}, silakan cek '$PM2_CMD logs eduguru'."
  fi
fi

echo "============================================================"
echo "🎉 DEPLOYMENT BERHASIL!"
echo "============================================================"
echo "📌 Langkah konfigurasi Nginx di aaPanel:"
echo "   1. Buka Website -> Domain Anda -> Reverse Proxy"
echo "   2. Add Reverse Proxy:"
echo "      - Proxy Name: eduguru"
echo "      - Target URL: http://127.0.0.1:${HEALTH_PORT}"
echo "   3. Atau salin isi file 'nginx.conf' ke tab Nginx Config situs Anda."
echo ""
echo "📊 Cek Log: $PM2_CMD logs eduguru"
echo "⏹️  Stop:     $PM2_CMD stop eduguru"
echo "🔄 Restart:  $PM2_CMD restart eduguru"
echo "============================================================"
