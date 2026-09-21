#!/bin/bash

# Run WP-CLI in the background
(
    echo "Waiting 15 seconds for MariaDB and WordPress initialization..."
    sleep 15
    
    cd /var/www/html

    if ! wp core is-installed --allow-root; then
        echo "Running WP-CLI installation..."
        wp core install \
          --url="https://ibenaiss.42.fr" \
          --title="Inception" \
          --admin_user="${WP_USER}" \
          --admin_password="${WP_PASSWORD}" \
          --admin_email="admin@ibenaiss.42.fr" \
          --allow-root

        echo "Creating second user..."
        wp user create --allow-root \
            seconduser second@ibenaiss.42.fr \
            --user_pass="password123" \
            --role=author

        echo "Applying custom debugging settings..."
        cat >> /var/www/html/wp-config.php << 'EOF'

// Disable all debugging
if ( ! defined( 'WP_DEBUG' ) ) {
    define( 'WP_DEBUG', false );
}
define( 'WP_DEBUG_LOG', false );
define( 'WP_DEBUG_DISPLAY', false );
define( 'SCRIPT_DEBUG', false );
define( 'WP_CACHE', true );
@ini_set( 'display_errors', 0 );
@ini_set( 'log_errors', 0 );
error_reporting(0);
EOF
        echo "WP-CLI setup complete!"
    fi
) &

# Chain to the official WordPress entrypoint
exec docker-entrypoint.sh "$@"