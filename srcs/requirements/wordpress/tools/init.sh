#!/bin/bash

cd /var/www/html

# Check if wp-config.php exists. If not, it's a fresh installation.
if [ ! -f wp-config.php ]; then
    echo "Setting up WordPress for the first time..."
    
    # Download WordPress core files
    wp core download --allow-root

    # Generate wp-config.php using your .env variables
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb \
        --allow-root

    # Wait for MariaDB to boot and accept connections
    echo "Waiting for database connection..."
    while ! wp db check --allow-root > /dev/null 2>&1; do
        sleep 3
    done
    echo "Database connected!"

    # Install WordPress automatically
    wp core install \
        --url="https://ibenaiss.42.fr" \
        --title="Inception" \
        --admin_user="${WP_USER}" \
        --admin_password="${WP_PASSWORD}" \
        --admin_email="admin@ibenaiss.42.fr" \
        --allow-root

    # Create the second user required by the subject
    wp user create --allow-root \
        seconduser second@ibenaiss.42.fr \
        --user_pass="password123" \
        --role=author

    echo "WordPress setup is fully complete!"
else
    echo "WordPress is already configured."
fi

# Start PHP-FPM in the foreground to keep the container alive
exec php-fpm