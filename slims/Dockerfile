# ============================================================
# SLiMS 9 Bulian — Image Produk Perpustakaan Digital Sekolah
# Build dari source release SLiMS 9.8.0.
# Database di-seed otomatis oleh entrypoint (self-seed),
# sehingga tidak bergantung pada preload image mysql.
# ============================================================
FROM php:8.3.13-apache

ARG SLIMS_VERSION=9.8.0
ARG SLIMS_URL="https://github.com/slims/slims9_bulian/archive/refs/tags/v${SLIMS_VERSION}.zip"

LABEL org.opencontainers.image.title="SLiMS Perpustakaan Digital Sekolah" \
      org.opencontainers.image.description="OPAC SLiMS 9.8.0 (image produk)" \
      org.opencontainers.image.version="${SLIMS_VERSION}" \
      org.opencontainers.image.source="https://github.com/your-org/perpustakaan-sekolah"

RUN apt-get update \
    && apt-get install -y libicu-dev libxml2-dev libzip-dev libpng-dev libonig-dev libjpeg62-turbo libjpeg62-turbo-dev libfreetype6-dev unzip \
    && docker-php-ext-install intl xml xmlwriter gettext mbstring zip mysqli pdo_mysql \
    && docker-php-ext-enable intl xml xmlwriter gettext mbstring zip mysqli pdo_mysql \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer \
    && ln -sf /usr/local/bin/composer /usr/bin/composer

# ---------- Source SLiMS ----------
WORKDIR /tmp
RUN curl -fsSL -o slims.zip "${SLIMS_URL}" \
    && unzip -q slims.zip \
    && mkdir -p /var/www/html \
    && cp -a /tmp/slims9_bulian-${SLIMS_VERSION}/. /var/www/html/ \
    && rm -rf /tmp/slims.zip /tmp/slims9_bulian-${SLIMS_VERSION} \
    && cd /var/www/html \
    && composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader \
    && chown -R www-data:www-data /var/www/html

# ---------- Direktori data dinamis ----------
RUN mkdir -p /var/www/html/files /var/www/html/images /var/www/html/repository

# ---------- SQL seed produk ----------
COPY sql/senayan.sql /opt/slims/seed/senayan.sql
COPY sql/sampledata.sql /opt/slims/seed/sampledata.sql

# ---------- Entrypoint ----------
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]
