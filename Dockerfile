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
    oniguruma-dev \ 
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip exif pcntl \
    && rm -rf /var/cache/apk/* /var/lib/apt/lists/*  # Clean up to reduce image size

# Copy Composer from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy application code into the container
COPY . /var/www
# COPY --chown=www-data:www-data . /var/www

# Set the correct permissions for Laravel (optional but recommended)
RUN chmod -R 775 /var/www/storage /var/www/bootstrap && \
    # chown -R www-data:www-data /var/www/storage /var/www/bootstrap && \
    chown -R www-data:www-data /var/www


    