FROM alpine:3.12

# inspired by https://hub.docker.com/r/trafex/alpine-nginx-php7/

LABEL Maintainer="Henrik Gebauer <code@henrik-gebauer.de>" \
      Description="minimalistic PHP base image"

EXPOSE 8080

ENV MUSL_LOCPATH="/usr/share/i18n/locales/musl"
# install locales, see https://github.com/Auswaschbar/alpine-localized-docker/
RUN set -ex \
  && apk --no-cache add libintl \
  && apk --no-cache --virtual .locale_build add \
    cmake \
    make \
    musl-dev \
    gcc \
    gettext-dev \
    git \
  && git clone https://gitlab.com/rilian-la-te/musl-locales \
  && cd musl-locales \
  && cmake -DLOCALE_PROFILE=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr . \
  && make \
  && make install \
  && cd .. \
  && rm -r musl-locales \
  && apk del .locale_build

RUN set -ex \
  && apk --no-cache add \
    php7 \
    php7-fpm \
    php7-opcache \
    nginx \
    supervisor \
    curl \
  && rm /etc/nginx/conf.d/default.conf \
  && mkdir /var/www/html \
  && adduser -u 82 -D -S -H -G www-data www-data \
  && rm /etc/crontabs/root \
  && echo "<?php phpinfo(); " > /var/www/html/index.php \
  && chown -R www-data:www-data /var/www/html /run /var/lib/nginx /var/log/nginx

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/custom.ini
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

CMD "/entrypoint.sh"

HEALTHCHECK CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
