FROM wordpress:latest

# Étape 1 : Installer les dépendances système (version corrigée)
RUN apt-get update && apt-get install -y \
    less \
    default-mysql-client \
    curl \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Étape 2 : Télécharger WP-CLI avec vérification
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp \
    && wp --allow-root --version

# Étape 3 : Copie des fichiers avec vérification
COPY docker-entrypoint.sh /usr/local/bin/
COPY scripts/seed-wp.sh /usr/local/bin/
COPY wp-config.php /var/www/html/
COPY .htaccess /var/www/html/

# Étape 4 : Configuration des permissions (version sécurisée)
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/seed-wp.sh \
    && chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Healthcheck amélioré
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD wp --allow-root core is-installed && wp --allow-root core verify-checksums || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]