FROM debian:bullseye

COPY tools/init.sh /usr/bin/

RUN chmod +x /usr/bin/init.sh

RUN apt update -y && apt upgrade -y && \
    apt install -y \
        curl \
        php7.4 \
        php7.4-fpm \
        php7.4-mysql \
        php7.4-gd \
        php7.4-mbstring \
        php7.4-xml \
        php7.4-curl \
        php7.4-zip \
        php7.4-soap \
        php7.4-intl \
        php7.4-bcmath \
        php7.4-opcache \
        mariadb-client \
        unzip \
        git && \
    apt clean && rm -rf /var/lib/apt/lists/*


    
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar ; chmod +x wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./config/www.conf /etc/php/7.4/fpm/pool.d/www.conf

EXPOSE 9000

RUN mkdir -p /var/www/wordpress

WORKDIR /var/www/wordpress

ENTRYPOINT [ "/usr/bin/init.sh" ]