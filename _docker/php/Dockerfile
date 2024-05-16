FROM php:8.2-fpm

ENV COMPOSER_HOME="/tmp/composer"
ARG SYSTEM_GROUP_ID=1000
ENV SYSTEM_GROUP_ID $SYSTEM_GROUP_ID

ARG SYSTEM_USER_ID=1000
ENV SYSTEM_USER_ID $SYSTEM_USER_ID

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN set -xe \
    && apt-get update  \
    && apt-get install -y \
        build-essential \
        libpng-dev \
        libjpeg62-turbo-dev \
        libonig-dev \
        libpq-dev \
        libzip-dev \
        libfreetype6-dev \
        locales \
        zip \
        jpegoptim optipng pngquant gifsicle \
        unzip \
        git \
        curl \
        libxml2-dev \
        libkrb5-dev \
        libc-client-dev \
        libicu-dev \
        libxslt-dev \
    # install PECL extensions \
        && pecl install -o -f redis \
    # configure PHP extensions \
        && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
        && docker-php-ext-configure intl \
    # install PHP extensions \
        && docker-php-ext-install \
            pdo \
            pdo_mysql \
            mbstring \
            exif \
            pcntl  \
            bcmath \
            gd \
            zip \
            soap \
            imap \
            intl \
            xsl \
    # enable PHP extensions (if need) \
        && docker-php-ext-enable \
            redis \
            imap \
    # Clear cache \
        && apt-get clean \
        && rm -rf \
            /var/lib/apt/lists/* \
            /tmp/pear

# Add user for laravel application
RUN groupadd -g $SYSTEM_GROUP_ID www \
    && useradd -u $SYSTEM_USER_ID -ms /bin/bash -g www www \
    && chown -R www:www /var/www

# Change current user to www
USER www:www

# Set working directory
WORKDIR /var/www

# copy composer (json|lock) files for dependencies layer caching
COPY --chown=www:www ./composer.* /var/www/

# copy application sources into image (completely)
COPY --chown=www:www . /var/www/ 

# Expose port 9000 and start php-fpm server
EXPOSE 9000

CMD ["php-fpm"]
