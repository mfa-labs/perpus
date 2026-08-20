#!/bin/sh
set -e

# ============================================================
# Init produk Grav — dijalankan oleh docker-entrypoint.sh
# bawaan image getgrav/grav (via /docker-entrypoint.d/).
# ============================================================

USER_DIR="/var/www/html/user"
ACCOUNT_FILE="$USER_DIR/accounts/admin.yaml"
FLAG_FILE="$USER_DIR/.admin_initialized"

# Rotasi password admin saat first run, agar tidak ada password
# hardcoded bawaan produk di semua instalasi.
if [ ! -f "$FLAG_FILE" ] && [ -f "$ACCOUNT_FILE" ]; then
  ADMIN_PASS="${GRAV_ADMIN_PASSWORD:-}"
  if [ -z "$ADMIN_PASS" ]; then
    ADMIN_PASS=$(openssl rand -base64 12 | tr -dc 'A-Za-z0-9' | head -c 16)
  fi

  ADMIN_HASH=$(php -r "echo password_hash(getenv('ADMIN_PASS'), PASSWORD_BCRYPT);" )

  # Tulis ulang admin.yaml dengan password baru (pertahankan state & akses)
  cat > "$ACCOUNT_FILE" <<EOF
state: enabled
email: admin@example.com
language: id
access:
  admin:
    login: true
    super: true
  site:
    login: true
fullname: 'Administrator Perpustakaan'
title: Administrator
hashed_password: $ADMIN_HASH
EOF

  touch "$FLAG_FILE"

  echo ""
  echo "========================================================"
  echo "  GRAV FIRST-TIME SETUP - ADMIN CREDENTIALS"
  echo "  Username : admin"
  echo "  Password : ${ADMIN_PASS}"
  echo "  URL      : https://<domain>/admin"
  echo "  Please change your password immediately after login!"
  echo "========================================================"
  echo ""
  unset ADMIN_HASH ADMIN_PASS
else
  echo "Grav admin already initialized, skipping."
fi

chown -R www-data:www-data "$USER_DIR" 2>/dev/null || true
