# Utiliser l'image officielle Nginx
FROM nginx:alpine

# Copier le fichier HTML et CSS dans le répertoire de Nginx
COPY ./index.html /usr/share/nginx/html/
COPY ./style.css /usr/share/nginx/html/
COPY ./img/ /usr/share/nginx/html/img/

# Exposer le port 80
EXPOSE 80
