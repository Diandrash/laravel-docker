# Gunakan image PHP resmi dengan Apache dan versi PHP 7.2
#FROM php:7.2-apache

# Install ekstensi PHP yang diperlukan oleh Laravel
#RUN apt-get update && apt-get install -y \
#    libzip-dev \
#    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
#COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set document root Apache ke /var/www/html/public
#WORKDIR /var/www/html

# Copy file Laravel dari direktori lokal ke container Docker
#COPY . .

# Installing from package manager
#RUN composer install

# Laravel serve
#CMD ["php artisan serve", "--host=0.0.0.0", "--port=8000"]

# Expose port 80 agar container dapat diakses dari luar
#EXPOSE 8000

# Stage 1: Build the application
FROM composer:latest as builder

# Set working directory
WORKDIR /app

# Copy composer.json and composer.lock
COPY composer.json . ./

# Install dependencies
RUN composer install --no-dev --no-scripts --prefer-dist --no-progress --no-interaction --optimize-autoloader

# Copy the rest of the application
COPY . .

# Generate optimized autoload files and cache
#RUN php artisan config:cache
#RUN php artisan route:cache
#RUN php artisan view:cache

# Stage 2: Set up the production environment
FROM php:7.2-fpm

# Set working directory
WORKDIR /var/www/html

# Copy application code from the builder stage
COPY --from=builder /app /var/www/html

# Install PHP extensions required by Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl && \
    docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Set the correct permissions for Laravel
#RUN chown -R www-data:www-data /var/www/html && \
#    chmod -R 755 /var/www/html

RUN php artisan -v config:cache && php artisan -v route:cache && php artisan -v view:cache

# Set the correct permissions for Laravel
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose port 9000 (for PHP-FPM)
EXPOSE 9000

# Start PHP-FPM service
CMD ["php-fpm"]
