FROM wordpress:latest

# 1. Installation des dépendances
RUN apt-get update && apt-get install -y \
    less \
    default-mysql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 2. Installation WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# 3. Copie des fichiers essentiels (sans .htaccess)
COPY docker-entrypoint.sh /usr/local/bin/
COPY scripts/seed-wp.sh /usr/local/bin/
COPY wp-config.php /var/www/html/

# 4. Création du .htaccess directement dans l'image
RUN echo "# BEGIN WordPress\n\
<IfModule mod_rewrite.c>\n\
RewriteEngine On\n\
RewriteBase /\n\
RewriteRule ^index\\.php$ - [L]\n\
RewriteCond %{REQUEST_FILENAME} !-f\n\
RewriteCond %{REQUEST_FILENAME} !-d\n\
RewriteRule . /index.php [L]\n\
</IfModule>\n\
# END WordPress" > /var/www/html/.htaccess

# 5. Configuration des permissions
RUN chmod +x /usr/local/bin/*.sh \
    && chown -R www-data:www-data /var/www/html \
    && chmod 644 /var/www/html/.htaccess \
    && chmod 600 /var/www/html/wp-config.php \
    && find /var/www/html -type d -exec chmod 755 {} \;

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD wp --allow-root core is-installed

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]