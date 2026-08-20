#!/bin/sh
set -e

# ============================================================
# Tulis konfigurasi tambahan produk (opac_url) dari environment.
# Dipakai halaman Katalog agar link benar di produksi (subdomain)
# maupun lokal (localhost:8082).
# ============================================================

EXTRA_FILE="/var/www/html/user/config/extra.yaml"
OPAC_URL="${OPAC_URL:-}"

if [ -n "$OPAC_URL" ]; then
  cat > "$EXTRA_FILE" <<EOF
# Konfigurasi tambahan produk — ditulis otomatis saat container start
extra:
  opac_url: '${OPAC_URL}'
EOF
  chown www-data:www-data "$EXTRA_FILE" 2>/dev/null || true
  echo "OPAC_URL ditulis: ${OPAC_URL}"
else
  echo "OPAC_URL tidak diset, gunakan placeholder bawaan."
fi
