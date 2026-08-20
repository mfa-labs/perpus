# ============================================================
# Grav CMS — Image Produk Perpustakaan Digital Sekolah
# Berbasis image resmi getgrav/grav:1.7 (Grav 1.7.53.2 + PHP 8.3)
# + ekstensi pdo_mysql (untuk plugin statistik SLiMS)
# + konten user/ produk (config, pages, theme, plugin, accounts).
#
# Entrypoint bawaan getgrav/grav otomatis:
#   - meng-install Grav ke volume kosong (GRAV_SETUP)
#   - menjalankan scheduler (GRAV_SCHEDULER)
#   - menjalankan script kustom di /docker-entrypoint.d/
# ============================================================
FROM getgrav/grav:1.7

LABEL org.opencontainers.image.title="Grav Perpustakaan Digital Sekolah" \
      org.opencontainers.image.description="Front-end website perpustakaan sekolah (Grav + konten produk)" \
      org.opencontainers.image.source="https://github.com/your-org/perpustakaan-sekolah"

# ---------- Ekstensi PHP ----------
# pdo_mysql dibutuhkan plugin statistik (query DB SLiMS).
RUN install-php-extensions pdo_mysql

# ---------- Plugin resmi tambahan (sitemap, feed, pagination, SEO) ----------
# Base image getgrav/grav punya webroot kosong (Grav di-install saat runtime),
# jadi kita install Grav dulu di layer ini untuk memakai GPM, lalu bersihkan
# webroot agar entrypoint runtime tetap meng-install fresh ke volume.
RUN curl -fsSL -o /tmp/grav-admin.zip "https://github.com/getgrav/grav/releases/download/1.7.53.2/grav-admin-v1.7.53.2.zip" \
    && unzip -q /tmp/grav-admin.zip -d /tmp \
    && cp -a /tmp/grav-admin/. /var/www/html/ \
    && rm -rf /tmp/grav-admin /tmp/grav-admin.zip \
    && cd /var/www/html \
    && bin/gpm install -y sitemap feed pagination seo \
    && chown -R www-data:www-data /var/www/html

# ---------- Bake konten & konfigurasi produk ----------
# user/ produk (config, pages, theme, plugin statistik, accounts)
COPY grav/user /var/www/html/user
# Hapus akun contoh bawaan grav-admin (admin.yaml kita jadi satu-satunya)
# dan halaman contoh bawaan (home, typography) agar tidak muncul di menu
RUN rm -f /var/www/html/user/accounts/admin.yaml.bak \
    && rm -rf /var/www/html/user/pages/01.home /var/www/html/user/pages/02.typography \
    && chown -R www-data:www-data /var/www/html/user

# PHP config ringan untuk Grav
COPY grav/php-grav.ini /usr/local/etc/php/conf.d/php-grav.ini

# ---------- Init produk ----------
# Script custom dijalankan otomatis oleh docker-entrypoint.sh bawaan Grav:
#   10-init-admin.sh  -> rotasi password admin saat first run
#   20-opac-url.sh    -> tulis URL OPAC dari env ke user/config/extra.yaml
COPY grav/docker-entrypoint.d/ /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/*.sh

WORKDIR /var/www/html
EXPOSE 80
