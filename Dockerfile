# use PHP 8.2
FROM php:7.2-fpm

WORKDIR /var/www/html/

#COPY ./ /var/www/html

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
    curl \
    unixodbc-dev

RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/debian/10/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

#RUN apt-get udpate && true

RUN pecl channel-update pecl.php.net
RUN pecl install sqlsrv-5.8.0
RUN pecl install pdo_sqlsrv-5.8.0
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd
#RUN printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.2/mods-available/sqlsrv.ini
#RUN printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.2/mods-available/pdo_sqlsrv.ini

RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18
RUN export PATH="$PATH:/opt/mssql-tools18/bin"

# Set the working directory
#COPY . /var/www/html

#RUN chown -R www-data:www-data /var/www/html \
#    && chmod -R 775 /var/www/html/storage

# install composer
COPY --from=composer:2.2 /usr/bin/composer /usr/local/bin/composer

# copy composer.json to workdir & install dependencies
#COPY . /var/www/html/

#RUN composer install
#RUN composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader

#RUN php artisan -v config:cache && php artisan -v route:cache && php artisan -v view:cache
#RUN php artisan -v migrate

#RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
#RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18
#RUN export PATH="$PATH:/opt/mssql-tools18/bin"

EXPOSE 9000

# Set the default command to run php-fpm
CMD ["php-fpm"]
