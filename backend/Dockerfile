FROM wordpress:latest

# Met à jour les paquets et installe les dépendances utiles
RUN apt-get update && apt-get install -y \
    less \
    default-mysql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Installe WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# Copie des scripts personnalisés
COPY backend/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY backend/scripts/seed-wp.sh /usr/local/bin/seed-wp.sh
COPY backend/wp-config.php /var/www/html/wp-config.php
COPY backend/.htaccess /tmp/.htaccess

# Donne les droits d’exécution et assure les bonnes permissions
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/seed-wp.sh \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Déclare ton entrypoint personnalisé
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh", "apache2-foreground"]



