FROM php:7.4-fpm-alpine3.15

RUN apk add --no-cache \
		$PHPIZE_DEPS \
		openssl-dev \
        bash \
        openrc \
        vim \
		acl \
		fcgi \
		file \
		gettext \
		git \
		gnu-libiconv \
        nginx supervisor\
		freetype freetype-dev \
        libpng libpng-dev \
        jpeg-dev \
        libjpeg-turbo-dev \
        linux-headers \
	;

# install grpc
RUN pecl install grpc-1.41.0

RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg

RUN NUMPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1); \
    docker-php-ext-install -j${NUMPROC} gd mysqli pdo pdo_mysql

# install composer 2
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# configurasi supervisor
COPY supervisord.ini /etc/supervisor.d/supervisord.ini

# configurasi nginx and proxy
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY proxy.conf /etc/nginx/includes/proxy.conf

# Configurasi php.ini
COPY php.ini /usr/local/etc/php/php.ini

# Directory runner
RUN mkdir -p /var/run/php && mkdir -p /var/run/nginx
