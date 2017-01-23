FROM php:latest
MAINTAINER Wesley Elfring <wesley@combustible.nl>

# Update packages and install Git and Zip (needed for Composer to run)
RUN apt-get update -yqq
RUN apt-get install git xvfb unzip -yqq

# Install MySQL and Xdebug (needed for phpunit code coverage)
RUN docker-php-ext-install pdo_mysql
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Install Composer and Prestissimo
RUN curl -sS https://getcomposer.org/installer | php && composer global require "hirak/prestissimo:^0.3"

# Install NPM and scommon global packages
RUN npm install -g n && n lts && npm install -g npm yarn gulp

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
