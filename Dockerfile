# Utiliser l'image de base Nginx officielle
FROM nginx:latest

# Copier les fichiers statiques (HTML, CSS, images, etc.) du répertoire de votre projet dans le répertoire racine de Nginx
COPY . /usr/share/nginx/html/

# Exposer le port 80 pour permettre les connexions HTTP
EXPOSE 80

# Commande par défaut pour démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
