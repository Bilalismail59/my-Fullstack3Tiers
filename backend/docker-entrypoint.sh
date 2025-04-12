#!/bin/bash
set -e

echo "Préparation de l’environnement WordPress..."

# Supprime le fichier PID s'il existe (Apache n'aime pas les restes)
if [ -f /var/run/apache2/apache2.pid ]; then
    echo "Suppression du fichier apache2.pid..."
    rm -f /var/run/apache2/apache2.pid
fi

# Copier .htaccess si absent
if [ ! -f /var/www/html/.htaccess ]; then
    echo "Copie du .htaccess"
    cp /tmp/.htaccess /var/www/html/
    chown www-data:www-data /var/www/html/.htaccess
fi

# Exécuter le script de seed si présent
if [ -f /usr/local/bin/seed-wp.sh ]; then
    echo "Exécution du seed..."
    bash /usr/local/bin/seed-wp.sh
fi

# Lancer le vrai entrypoint WordPress
echo "Lancement de WordPress..."
exec docker-entrypoint.sh "$@"






