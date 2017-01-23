FROM php:latest
MAINTAINER Wesley Elfring <wesley@combustible.nl>

# Update packages and install Git, the Virtual Framebuffer and Zip (needed for Composer to run)
RUN apt-get update -yqq
RUN apt-get install git xvfb unzip -yqq

# Install MySQL and Xdebug (needed for phpunit code coverage)
RUN docker-php-ext-install pdo_mysql
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Install Composer and Prestissimo
RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require "hirak/prestissimo:^0.3"

# Install PHPUnit
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar && sudo mv phpunit.phar /usr/local/bin/phpunit

# Install NPM and scommon global packages
RUN npm install -g n && n lts && npm install -g npm yarn gulp

# At some time in the future, we may cache NPM packages, see http://bitjudo.com/blog/2014/03/13/building-efficient-dockerfiles-node-dot-js/
# We don't need this with Shippable's Cache
# ADD package.json /tmp/package.json
# RUN cd /tmp && npm install
# RUN mkdir -p /opt/app && cp -a /tmp/node_modules /opt/app/

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
