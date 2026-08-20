#!/bin/sh
set -e

# ============================================================
# Entrypoint SLiMS — produk Perpustakaan Digital Sekolah
# 1. Tulis config database dari environment
# 2. Tunggu database siap
# 3. Seed database otomatis (skema + sample) bila belum ada
# 4. Randomisasi password admin saat first run
# ============================================================

# ---------- 1. Konfigurasi environment & database ----------
cat <<EOF >/var/www/html/config/env.php
<?php
\$env = "${ENV:-production}";
EOF

cat <<EOF >/var/www/html/config/database.php
<?php
return [
    'default_profile' => 'SLiMS',
    'proxy' => false,
    'nodes' => [
        'SLiMS' => [
            'host' => '${DB_HOST}',
            'database' => '${DB_NAME}',
            'port' => '${DB_PORT}',
            'username' => '${DB_USER}',
            'password' => '${DB_PASS}',
            'options' => [
                'storage_engine' => 'MyISAM'
            ]
        ]
    ]
];
EOF

mkdir -p /var/www/html/files /var/www/html/images /var/www/html/repository
chown -R www-data:www-data /var/www/html/config /var/www/html/files /var/www/html/images /var/www/html/repository

echo "Konfigurasi SLiMS ditulis ke /var/www/html/config/"

# ---------- 2. Tunggu database siap ----------
echo "Menunggu database siap..."
until php -r "
\$conn = new mysqli(getenv('DB_HOST'), getenv('DB_USER'), getenv('DB_PASS'), getenv('DB_NAME'), (int)getenv('DB_PORT'));
exit(\$conn->connect_error ? 1 : 0);
" 2>/dev/null; do
  echo "  Database belum siap, coba lagi dalam 2 detik..."
  sleep 2
done
echo "Database siap."

# ---------- 3. Seed database (self-seed, hanya saat kosong) ----------
SEED_FLAG="/var/www/html/files/.db_seeded"

if [ ! -f "$SEED_FLAG" ]; then
  echo "Menjalankan seed database SLiMS..."
  # Urut: skema (senayan.sql) dulu, lalu data contoh (sampledata.sql)
  for f in /opt/slims/seed/senayan.sql /opt/slims/seed/sampledata.sql; do
    [ -f "$f" ] || continue
    echo "  Import: $f"
    php -r "
\$conn = new mysqli(getenv('DB_HOST'), getenv('DB_USER'), getenv('DB_PASS'), getenv('DB_NAME'), (int)getenv('DB_PORT'));
if (\$conn->connect_error) { fwrite(STDERR, 'DB connection failed: ' . \$conn->connect_error . PHP_EOL); exit(1); }
\$sql = file_get_contents(\$argv[1]);
if (\$conn->multi_query(\$sql)) {
    do {
        if (\$result = \$conn->store_result()) { \$result->free(); }
        if (\$conn->more_results()) {
            if (!\$conn->next_result()) {
                fwrite(STDERR, '  Warning (dilanjutkan): ' . \$conn->error . PHP_EOL);
                break;
            }
        }
    } while (\$conn->more_results());
} else {
    fwrite(STDERR, '  Warning (dilanjutkan): ' . \$conn->error . PHP_EOL);
}
\$conn->close();
echo '  OK' . PHP_EOL;
" "/opt/slims/seed/$(basename "$f")"
  done
  touch "$SEED_FLAG"
  echo "Seed database selesai."
else
  echo "Database sudah di-seed, skip."
fi

# ---------- 4. Rotasi password admin (first run) ----------
INIT_FLAG="/var/www/html/files/.admin_initialized"
if [ ! -f "$INIT_FLAG" ]; then
  ADMIN_PASS=$(openssl rand -base64 12 | tr -dc 'A-Za-z0-9' | head -c 16)
  export ADMIN_PASS
  ADMIN_HASH=$(php -r "echo md5(getenv('ADMIN_PASS'));")
  export ADMIN_HASH

  php -r "
\$conn = new mysqli(getenv('DB_HOST'), getenv('DB_USER'), getenv('DB_PASS'), getenv('DB_NAME'), (int)getenv('DB_PORT'));
if (\$conn->connect_error) {
    echo 'DB connection failed: ' . \$conn->connect_error . PHP_EOL;
    exit(1);
}
\$stmt = \$conn->prepare('UPDATE user SET passwd=? WHERE username=?');
\$hash = getenv('ADMIN_HASH');
\$user = 'admin';
\$stmt->bind_param('ss', \$hash, \$user);
\$stmt->execute();
if (\$stmt->affected_rows > 0) {
    echo 'Admin password updated successfully.' . PHP_EOL;
} else {
    echo 'Warning: admin user not found or password unchanged.' . PHP_EOL;
}
\$stmt->close();
\$conn->close();
"

  touch "$INIT_FLAG"
  unset ADMIN_HASH

  echo ""
  echo "========================================================"
  echo "  SLIMS FIRST-TIME SETUP - ADMIN CREDENTIALS"
  echo "  Username : admin"
  echo "  Password : ${ADMIN_PASS}"
  echo "  Please change your password immediately after login!"
  echo "========================================================"
  echo ""

  unset ADMIN_PASS
else
  echo "Admin password already initialized, skipping."
fi

exec "$@"
