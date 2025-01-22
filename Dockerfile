# Use PHP 8.2 FPM (Debian-based) as the base image
FROM php:8.2-fpm AS base

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libfreetype6-dev \
    libzip-dev \
    libonig-dev \
    libpq-dev \
    libssl-dev \
    libsodium-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) bcmath ctype json mbstring openssl pdo pdo_mysql tokenizer xml zip fileinfo sodium \
    && rm -rf /var/lib/apt/lists/*

# Copy Composer from the official Composer image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy application code and set ownership
COPY . /var/www
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Set the default user to www-data for better security
USER www-data

