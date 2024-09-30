# Gunakan image PHP resmi dengan Apache dan versi PHP 7.2
FROM php:7.2-apache

# Install ekstensi PHP yang diperlukan oleh Laravel
RUN apt-get update && apt-get install -y \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set document root Apache ke /var/www/html/public
WORKDIR /var/www/html

# Copy file Laravel dari direktori lokal ke container Docker
COPY . .

# Expose port 80 agar container dapat diakses dari luar
EXPOSE 80
