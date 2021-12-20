FROM php:7.4-fpm

#Install ekstension php
RUN apt-get update -y \
    && apt-get install -y git vim libzip-dev zip openssl libmcrypt-dev libpq-dev libonig-dev supervisor libpng-dev libcurl4-openssl-dev\
    build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev libfreetype6-dev libjpeg62-turbo-dev\
    && pecl install mcrypt-1.0.4 grpc \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql -j$(nproc) gd \
    && docker-php-ext-enable mcrypt 

WORKDIR /install

#Install elastic APM
RUN curl -LO https://github.com/elastic/apm-agent-php/archive/refs/tags/v1.3.1.tar.gz \
    && tar -zxvf v1.3.1.tar.gz && cd apm-agent-php-1.3.1/src/ext && phpize && CFLAGS="-std=gnu99" ./configure --enable-elastic_apm && make clean \
    && make && make install

#Install nginx
RUN curl -LO https://nginx.org/download/nginx-1.20.1.tar.gz && tar -zxvf nginx-1.20.1.tar.gz\
    && cd nginx-1.20.1 && ./configure --prefix=/var/www/html --sbin-path=/usr/local/bin/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --with-pcre  --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --with-http_ssl_module --with-http_image_filter_module=dynamic --modules-path=/etc/nginx/modules --with-http_v2_module --with-stream=dynamic --with-http_addition_module --with-http_mp4_module && make && make install && cd ..

#Install comoposer
RUN curl -L -o /usr/local/bin/composer https://getcomposer.org/download/2.1.5/composer.phar && chmod +x /usr/local/bin/composer

#Configurasi supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#Configurasi nginx
COPY site.conf /etc/nginx/nginx.conf

#Configurasi php ini
COPY php.ini /usr/local/etc/php/php.ini

# Directory runner
RUN mkdir -p /var/run/php && mkdir -p /var/run/nginx

