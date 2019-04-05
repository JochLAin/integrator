FROM php:7.1-fpm

# Add user 1000
RUN useradd -u 1000 -d /home/user -m user
WORKDIR /home/docker

ARG PHP_APCU_VERSION=5.1.7
ARG PHP_XDEBUG_VERSION=2.5.0

# Install packages needed
RUN apt-get update \
    && apt install -y \
        build-essential \
        cron \
        curl \
        cron \
        git \
        libcurl3-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libmemcached-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libpng-dev \
        libssl-dev \
        libxslt-dev \
        libxslt1-dev \
        nano \
        openssl \
        zlib1g-dev

# Extract PHP source before work with
RUN docker-php-source extract

# Install APCU
RUN curl -L -o /tmp/apcu-$PHP_APCU_VERSION.tgz https://pecl.php.net/get/apcu-$PHP_APCU_VERSION.tgz \
    && tar xfz /tmp/apcu-$PHP_APCU_VERSION.tgz \
    && rm -r /tmp/apcu-$PHP_APCU_VERSION.tgz \
    && mv apcu-$PHP_APCU_VERSION /usr/src/php/ext/apcu

# Configure GD Extension
RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install PHP Extensions
RUN docker-php-ext-install -j$(nproc) \
        apcu \
        bcmath \
        calendar \
        ctype \
        curl \
        dom \
        gd \
        hash \
        intl \
        iconv \
        json \
        mbstring \
        mcrypt \
        opcache \
        pdo_mysql \
        soap \
        xml \
        xsl \
        zip
# Delete PHP source after work
RUN docker-php-source delete

# Install Memcached
RUN pecl install memcached \
  docker-php-ext-enable memcached

ARG BUILD_ENV=dev

# Install XDebug if dev environment (default)
RUN if [ "$BUILD_ENV" = "dev" ]; then \
    docker-php-source extract \
    && curl -L -o /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz http://xdebug.org/files/xdebug-$PHP_XDEBUG_VERSION.tgz \
    && tar xfz /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz \
    && rm -r \
        /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz \
    && mv xdebug-$PHP_XDEBUG_VERSION /usr/src/php/ext/xdebug \
    && docker-php-ext-install \
        xdebug \
    && docker-php-source delete \
; fi

# Install composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

# Copy php configuration file
COPY ./docker/engine/php.ini /usr/local/etc/php/conf.d/custom.ini

# Configure cron
RUN service cron start

# Configure entrypoint
COPY ./docker/engine/entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Install project
COPY ./src /home/docker
RUN if [ "$BUILD_ENV" = "dev" ]; then composer install \
    ; elif [ "$BUILD_ENV" = "prod" ]; then composer install -o --no-progress --no-scripts \
    ; fi

# Run php when container start
CMD ["php-fpm"]
