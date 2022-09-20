FROM php:7.4-apache

RUN apt-get update -q -y \
  && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y -q --no-install-recommends \
  apt-utils \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  libxml2-dev \
  libmcrypt-dev \
  libmemcached11 \
  libmemcachedutil2 \
  libmemcached-dev \
  libz-dev \
  build-essential \
  git \
  rsyslog \
  default-mysql-client \
  zip \
  vim \
  wget \
  curl \
  nodejs \
  supervisor \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y \
  && npm install node-sass \
  && rm -rf /var/lib/apt/lists/*

# Install xDebug
RUN docker-php-source extract \
  && git clone -b php7 https://github.com/php-memcached-dev/php-memcached.git /usr/src/php/ext/memcached \
  && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
  && docker-php-ext-install -j$(nproc) \
  opcache \
  gd \
  pdo_mysql \
  && docker-php-source delete

RUN pecl install mcrypt \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug mcrypt

# Install Drush
RUN curl -fsSL "https://github.com/drush-ops/drush/releases/download/8.4.11/drush.phar" -o /usr/local/bin/drush  && \
  chmod +x /usr/local/bin/drush

COPY docker/php/custom.ini docker/php/xdebug.ini ${PHP_INI_DIR}/conf.d/

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

RUN a2enmod rewrite

COPY docroot/ /var/www/html
COPY docker/docker-entrypoint.sh /usr/local/bin
COPY docker/supervisor.conf /etc/supervisor/supervisord.conf

WORKDIR /var/www/html

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
  && chmod -R 755 /var/www/html \
  && chown -R www-data:www-data /var/www/html

ENTRYPOINT ["docker-entrypoint.sh"]
