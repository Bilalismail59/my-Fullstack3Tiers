#!/bin/bash
set -e
cd /var/www/html

echo "Attente de la base de données..."

# Attente active jusqu'à ce que la BDD soit disponible
until mysql -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e "SHOW DATABASES;" > /dev/null 2>&1; do
    echo "En attente de la BDD..."
    sleep 3
done

echo "BDD disponible, on continue..."

# Augmenter la mémoire disponible pour WP-CLI
export WP_CLI_PHP_ARGS='-d memory_limit=512M'

# Télécharger WordPress si le cœur n’est pas encore présent
if [ ! -f wp-settings.php ]; then
    echo "Téléchargement de WordPress..."
    php -d memory_limit=512M /usr/local/bin/wp core download --allow-root
fi

# Installation initiale de WordPress si nécessaire
if ! wp core is-installed --allow-root; then
    echo "Installation de WordPress..."
    wp core install \
        --url="${WORDPRESS_SITEURL}" \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    echo "Installation des plugins..."
    wp plugin install tablepress --activate --allow-root || true
    wp plugin install akismet --activate --allow-root || true

    echo "Configuration des permaliens..."
    wp rewrite structure '/%postname%/' --allow-root
else
    echo "WordPress déjà installé, aucun changement nécessaire."
fi
