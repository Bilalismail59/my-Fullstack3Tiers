#!/bin/bash
set -e

# Attendre que MySQL soit prêt
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    sleep 1
done

# Installer WordPress si ce n'est pas déjà fait
if ! $(wp core is-installed --allow-root); then
    wp core install \
        --url="$WORDPRESS_SITEURL" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --skip-email
    
    # Installer des plugins
    wp plugin install akismet --activate --allow-root
    wp plugin install wordpress-seo --activate --allow-root
    
    # Configurer les permaliens
    wp rewrite structure '/%postname%/' --allow-root
fi