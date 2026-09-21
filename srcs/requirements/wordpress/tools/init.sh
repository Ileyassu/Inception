#!/bin/bash

# Run the WP-CLI installation in the background
(
    # Wait for MariaDB to be ready and for the official entrypoint to finish unpacking WP
    sleep 15
    
    cd /var/www/html

    # Check if WordPress is already configured
    if ! wp core is-installed --allow-root; then
        echo "Installing WordPress..."
        wp core install \
          --url="https://ibenaiss.42.fr" \
          --title="ibenaiss portfolio" \
          --admin_user="${WP_USER}" \
          --admin_password="${WP_PASSWORD}" \
          --admin_email="you@example.com" \
          --allow-root

        echo "Appending custom debug config..."
        cat >> /var/www/html/wp-config.php << 'EOF'

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
        echo "WordPress setup complete."
    fi
) &

# Execute the official entrypoint in the foreground to start PHP
exec docker-entrypoint.sh php-fpm