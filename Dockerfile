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
    icu-dev \
    libzip-dev \
    libpq-dev \
    oniguruma-dev \
    zip \
    vim \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
       gd \
       mysqli \
       pdo \
       pdo_mysql \
       pdo_pgsql \
       bcmath \
       mbstring \
       zip \
       exif \
       pcntl \
       intl \
       opcache \
    && rm -rf /var/cache/apk/* /var/lib/apt/lists/*  # Clean up to reduce image size

# Copy Composer from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy application code into the container
COPY . /var/www
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Expose port and start command
EXPOSE 9000
CMD ["php-fpm"]
