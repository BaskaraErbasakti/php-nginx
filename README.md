## PHP-NGINX
Build base images php with nginx

## BUILD BASE IMAGE DOCKER
```sh
docker build -t php-nginx .
```

### Example Dockerfile
```Dockerfile
FROM php-nginx 

WORKDIR /var/www/app

COPY . .

RUN composer install

RUN chown -R www-data:www-data /var/www/app

EXPOSE 80

CMD ["/usr/bin/supervisord"]

```