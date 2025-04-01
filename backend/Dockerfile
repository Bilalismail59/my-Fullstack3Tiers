# Utilisation de l'image officielle WordPress avec Apache
FROM wordpress:latest

# 1. Installation des dépendances système avec nettoyage automatique
RUN apt-get update && apt-get install -y \
    less \
    default-mysql-client \
    vim \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 2. Installation sécurisée de WP-CLI (version stable)
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp \
    && wp --allow-root cli version

# 3. Copie des fichiers avec gestion d'erreur robuste
COPY docker-entrypoint.sh /usr/local/bin/
COPY scripts/seed-wp.sh /usr/local/bin/
COPY wp-config.php /var/www/html/wp-config.php
RUN mkdir -p /var/www/html/wp-content/uploads \
    && touch /var/www/html/.htaccess \
    && [ -f .htaccess ] && cp .htaccess /var/www/html/ || true

# 4. Configuration avancée des permissions
RUN chmod +x /usr/local/bin/*.sh \
    && chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && chmod 600 /var/www/html/wp-config.php

# 5. Healthcheck amélioré
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD wp --allow-root core is-installed && curl -f http://localhost/ || exit 1

# 6. Entrypoint et commande par défaut
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]