# SLiMS 9 Bulian — Dockerfile untuk deployment di root docroot (Easypanel)
# Mengikuti Dockerfile resmi slims/slims9_bulian (SLiMS di /var/www/html)
FROM php:8.3.13-apache

RUN apt-get update \
    && apt-get install -y libicu-dev libxml2-dev libzip-dev libpng-dev libonig-dev libjpeg62-turbo libjpeg62-turbo-dev libfreetype6-dev unzip \
    && docker-php-ext-install intl xml xmlwriter gettext mbstring zip mysqli pdo_mysql \
    && docker-php-ext-enable intl xml xmlwriter gettext mbstring zip mysqli pdo_mysql \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd

RUN a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer \
    && ln -sf /usr/local/bin/composer /usr/bin/composer

# Unduh source SLiMS 9 (release 9.8.0)
ARG SLIMS_VERSION=9.8.0
RUN curl -fsSL -o /tmp/slims.zip "https://github.com/slims/slims9_bulian/archive/refs/tags/v${SLIMS_VERSION}.zip" \
    && unzip /tmp/slims.zip -d /tmp \
    && mkdir -p /var/www/html \
    && cp -a /tmp/slims9_bulian-${SLIMS_VERSION}/. /var/www/html/ \
    # Salin cadangan source untuk inisialisasi volume kosong saat runtime
    && mkdir -p /opt/slims_source \
    && cp -a /tmp/slims9_bulian-${SLIMS_VERSION}/. /opt/slims_source/ \
    && rm -rf /tmp/slims.zip /tmp/slims9_bulian-${SLIMS_VERSION} \
    && cd /var/www/html \
    && /usr/local/bin/composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader \
    && cp -a /var/www/html/vendor /opt/slims_source/vendor

# Persiapkan direktori data dinamis
RUN mkdir -p /var/www/html/files /var/www/html/images /var/www/html/repository \
    && chown -R www-data:www-data /var/www/html

# Entrypoint + konfigurasi
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]
