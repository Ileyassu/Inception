#!/bin/bash

(
    # Give the official entrypoint a few seconds to extract the core files
    sleep 5
    cd /var/www/html

    echo "Waiting for MariaDB to be fully initialized..."
    # Smart loop: keep trying to connect every 3 seconds until it succeeds
    while ! wp db check --allow-root; do
        sleep 3
    done
    echo "MariaDB is up! Starting WordPress configuration..."

    if ! wp core is-installed --allow-root; then
        wp core install \
          --url="https://ibenaiss.42.fr" \
          --title="Inception" \
          --admin_user="${WP_USER}" \
          --admin_password="${WP_PASSWORD}" \
          --admin_email="admin@ibenaiss.42.fr" \
          --allow-root

        wp user create --allow-root \
            seconduser second@ibenaiss.42.fr \
            --user_pass="password123" \
            --role=author

        echo "WordPress completely installed and configured!"
    else
        echo "WordPress is already installed."
    fi
) > /proc/1/fd/1 2>&1 & 
# ^ The line above forces all output to show up in 'docker compose logs wordpress'

# Chain to the official WordPress entrypoint
exec docker-entrypoint.sh php-fpm