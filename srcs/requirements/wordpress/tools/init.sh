#!/bin/bash 


mkdir -p /var/www/wordpress
cd /var/www/wordpress
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp core download --allow-root

echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h"mariadb" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
    sleep 2
done
echo "MariaDB is ready!"

wp config create \
  --dbname=wordpress \
  --dbuser="${MYSQL_USER}" \
  --dbpass="${MYSQL_PASSWORD}" \
  --dbhost=mariadb \
  --allow-root

wp core install \
  --url="https://ibenaiss.42.fr" \
  --title="ibenaiss portfolio" \
  --admin_user="${WP_USER}" \
  --admin_password=${WP_PASSWORD} \
  --admin_email="you@example.com" \
  --allow-root

cat >> /var/www/wordpress/wp-config.php << 'EOF'

// Disable all debugging
if ( ! defined( 'WP_DEBUG' ) ) {
    define( 'WP_DEBUG', false );
}

define( 'WP_DEBUG_LOG', false );
define( 'WP_DEBUG_DISPLAY', false );
define( 'SCRIPT_DEBUG', false );
define( 'WP_CACHE', true );
/* That's all, stop editing! Happy publishing. */
@ini_set( 'display_errors', 0 );
@ini_set( 'log_errors', 0 );
error_reporting(0);
EOF

mkdir -p /run/php

php-fpm7.4 -F