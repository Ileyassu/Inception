FROM wordpress:fpm

# WP-CLI database commands require the MariaDB client utilities.
RUN apt-get update \
    && apt-get install -y --no-install-recommends mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# WP-CLI needs more memory than PHP-FPM's default while extracting WordPress.
ENV WP_CLI_PHP_ARGS="-d memory_limit=512M"

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy and assign our custom script
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT ["init.sh"]