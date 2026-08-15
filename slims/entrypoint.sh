#!/bin/sh
set -e

# SLiMS dijalankan dari root docroot /var/www/html (pola image resmi).
# Volume slims_data memuat seluruh instalasi + konfigurasi.
# Source asli (untuk mengisi volume kosong) ada di /opt/slims_source.

if [ ! -f /var/www/html/config/database.php ]; then
  echo "Menyiapkan SLiMS di /var/www/html (volume kosong)..."
  cp -a /opt/slims_source/. /var/www/html/
fi

# Tulis konfigurasi environment
cat <<EOF >/var/www/html/config/env.php
<?php
\$env = "${ENV:-production}";
EOF

# Tulis konfigurasi database
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

echo "Konfigurasi SLiMS ditulis ke /var/www/html/config/"

# Pastikan direktori data dinamis dapat ditulis
mkdir -p /var/www/html/files /var/www/html/images /var/www/html/repository
chown -R www-data:www-data /var/www/html/files /var/www/html/images /var/www/html/repository /var/www/html/config

# Tunggu database siap
echo "Menunggu database siap..."
until php -r "
\$conn = new mysqli(getenv('DB_HOST'), getenv('DB_USER'), getenv('DB_PASS'), getenv('DB_NAME'), (int)getenv('DB_PORT'));
exit(\$conn->connect_error ? 1 : 0);
" 2>/dev/null; do
  echo "  Database belum siap, coba lagi dalam 2 detik..."
  sleep 2
done
echo "Database siap."

# Randomisasi password admin saat pertama kali start (perilaku image resmi)
INIT_FLAG="/var/www/html/files/.admin_initialized"
if [ ! -f "$INIT_FLAG" ]; then
  ADMIN_PASS=$(openssl rand -base64 12 | tr -dc 'A-Za-z0-9' | head -c 16)
  export ADMIN_PASS
  ADMIN_HASH=$(php -r "echo password_hash(getenv('ADMIN_PASS'), PASSWORD_BCRYPT);")
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
