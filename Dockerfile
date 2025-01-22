# Use the latest PHP version based on Alpine for a smaller image
FROM php:8.1-fpm-alpine as base

# Set working directory
WORKDIR /var/www

# Install required dependencies
RUN apk add --no-cache \
    build-base \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    freetype-dev \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    libpq-dev \
    openssl-dev \
    libsodium-dev \
    libxml2-dev

# Configure and install PHP extensions
RUN docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    --with-webp=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    ctype \
    json \
    openssl \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    tokenizer \
    xml \
    fileinfo \
    sodium \
    mbstring \
    zip \
    exif \
    pcntl

# Clean up
RUN rm -rf /var/cache/apk/* /var/lib/apt/lists/*

# Copy Composer from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy application code into the container
COPY . /var/www
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache
