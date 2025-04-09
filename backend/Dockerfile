FROM wordpress:latest

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    less \
    default-mysql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Installer WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# Copier nos fichiers
#COPY backend/docker-entrypoint.sh /usr/local/bin/
#COPY backend/scripts/seed-wp.sh /usr/local/bin/
#COPY backend/wp-config.php /var/www/html/
#COPY backend/.htaccess /var/www/html/ 

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
