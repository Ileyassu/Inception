#!/bin/bash

set -e

cd /var/www/html

configure_dynamic_site_url() {
    if [ -f wp-config.php ] && ! grep -q "INCEPTION_DYNAMIC_SITE_URL" wp-config.php; then
        printf '%s\n' \
            "/* INCEPTION_DYNAMIC_SITE_URL */" \
            "\$inception_host = \$_SERVER['HTTP_HOST'] ?? 'ibenaiss.42.fr';" \
            "\$inception_scheme = (!empty(\$_SERVER['HTTPS']) && \$_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';" \
            "define('WP_HOME', \$inception_scheme . '://' . \$inception_host);" \
            "define('WP_SITEURL', \$inception_scheme . '://' . \$inception_host);" \
            >> wp-config.php
    fi
}

configure_dynamic_site_url

# Keep the CLI installer independent from PHP-FPM's smaller runtime limit.
wp() {
    php -d memory_limit=512M /usr/local/bin/wp "$@"
}

# Check the database state instead of only checking wp-config.php. A failed
# install can leave wp-config.php behind while WordPress remains uninstalled.
if ! wp core is-installed --allow-root > /dev/null 2>&1; then
    echo "Setting up WordPress..."

    # Download WordPress core files when the persistent volume is empty.
    if [ ! -f index.php ]; then
        wp core download --allow-root
    fi

    # Generate wp-config.php when it does not exist yet.
    if [ ! -f wp-config.php ]; then
        wp config create \
            --dbname="${MYSQL_DATABASE}" \
            --dbuser="${MYSQL_USER}" \
            --dbpass="${MYSQL_PASSWORD}" \
            --dbhost=mariadb \
            --allow-root
    fi

    configure_dynamic_site_url

    echo "Checking the WordPress database connection..."
    attempts=0
    until mariadb \
        --skip-ssl \
        --host=mariadb \
        --user="${MYSQL_USER}" \
        --password="${MYSQL_PASSWORD}" \
        "${MYSQL_DATABASE}" \
        --execute="SELECT 1" > /dev/null 2>&1; do
        attempts=$((attempts + 1))
        if [ "$attempts" -ge 20 ]; then
            echo "WordPress could not connect to the database with the configured credentials." >&2
            mariadb \
                --skip-ssl \
                --host=mariadb \
                --user="${MYSQL_USER}" \
                --password="${MYSQL_PASSWORD}" \
                "${MYSQL_DATABASE}" \
                --execute="SELECT 1"
            exit 1
        fi
        sleep 3
    done
    echo "Database connected."

    # Install WordPress automatically when the database is not initialized.
    wp core install \
        --url="https://ibenaiss.42.fr" \
        --title="Inception" \
        --admin_user="${WP_USER}" \
        --admin_password="${WP_PASSWORD}" \
        --admin_email="admin@ibenaiss.42.fr" \
        --allow-root

    # Create the second user required by the subject when it does not exist.
    if ! wp user get seconduser --allow-root > /dev/null 2>&1; then
        wp user create --allow-root \
            seconduser second@ibenaiss.42.fr \
            --user_pass="password123" \
            --role=author
    fi

    echo "WordPress setup is fully complete!"
else
    echo "WordPress is already configured."
fi

# Start PHP-FPM in the foreground to keep the container alive
exec php-fpm