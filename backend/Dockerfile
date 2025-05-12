FROM wordpress:6.5-php8.2-apache

# Variables d'environnement pour la configuration WordPress
ENV WORDPRESS_DB_HOST=db \
    WORDPRESS_DB_USER=wordpress \
    WORDPRESS_DB_PASSWORD=wordpress \
    WORDPRESS_DB_NAME=wordpress \
    WORDPRESS_DEBUG=false

# Installation des dépendances et outils
RUN apt-get update && apt-get install -y \
    less \
    default-mysql-client \
    curl \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Installation de WP-CLI (version stable)
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp \
    && wp --allow-root --version

# Configuration Apache optimisée
RUN { \
    echo '<Directory /var/www/html>'; \
    echo '  Options FollowSymLinks'; \
    echo '  AllowOverride All'; \
    echo '  Require all granted'; \
    echo '  DirectoryIndex index.php'; \
    echo '</Directory>'; \
    echo 'ServerSignature Off'; \
    echo 'ServerTokens Prod'; \
} > /etc/apache2/conf-available/wordpress-optimization.conf \
    && a2enconf wordpress-optimization

# Copie des fichiers de configuration
COPY backend/wp-config.php /usr/src/wordpress/
COPY backend/.htaccess /usr/src/wordpress/
COPY backend/.htaccess /tmp/.htaccess
COPY backend/docker-entrypoint.sh /usr/local/bin/
COPY backend/scripts/seed-wp.sh /usr/local/bin/

# Fix des permissions et préparation
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/seed-wp.sh \
    && chown -R www-data:www-data /usr/src/wordpress \
    && find /usr/src/wordpress -type d -exec chmod 755 {} \; \
    && find /usr/src/wordpress -type f -exec chmod 644 {} \; \
    && a2enmod rewrite expires headers

# Santé check
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
