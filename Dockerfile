FROM alpine:edge
MAINTAINER Luca Lusso <llusso@wellnet.it>

# Install PHP7 with needed exstentions and composer with hirak/prestissimo.
RUN apk add --no-cache \
    php7 \
    php7-dom \
    php7-curl \
    php7-json \
    php7-phar \
    php7-openssl \
    php7-mbstring \
    php7-ctype \
    php7-pdo_mysql \
    php7-session \
    curl \
    && rm -fr /var/cache/apk/* \
    && ln -s /usr/bin/php7 /usr/bin/php \
    && curl -sS https://getcomposer.org/installer | php -- --filename=composer \
    --install-dir=/usr/bin --version=1.0.0 \
    && composer global require "hirak/prestissimo:^0.3"

RUN mkdir /tests
RUN mkdir /tests/artifacts
ADD composer.json /tests/composer.json
WORKDIR /tests

# Install and initialize Behat, create folder for artifacts.
RUN composer install

CMD ["/tests/bin/behat", "-f", "pretty", "-o", "/tests/artifacts/pretty.out", "-f", "progress", "-o", "std"]
