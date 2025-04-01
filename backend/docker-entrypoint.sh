#!/bin/bash
set -e

# Exécute le entrypoint original de WordPress
docker-entrypoint.sh "$@"

# Vos customisations supplémentaires ici
# Par exemple : 
if [ ! -f /var/www/html/.htaccess ]; then
    cp /tmp/.htaccess /var/www/html/
    chown www-data:www-data /var/www/html/.htaccess
fi

# Exécute le script de seed si besoin
if [ -f /usr/local/bin/seed-wp.sh ]; then
    bash /usr/local/bin/seed-wp.sh
fi

exec "$@"