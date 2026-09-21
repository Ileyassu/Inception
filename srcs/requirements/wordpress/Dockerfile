FROM wordpress:fpm

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY wp-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp-setup.sh

ENTRYPOINT ["wp-setup.sh"]
CMD ["php-fpm"]