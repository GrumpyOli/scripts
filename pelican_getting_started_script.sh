#!/bin/bash

# Vérifier si l'utilisateur a les droits suffisants (root ou sudo)
if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté avec des privilèges sudo ou root."
  exit 1
fi

# Mettre à jour les paquets du système
echo "Mise à jour des paquets..."
apt update -y

# Installer les dépendances de base
echo "Installation de curl, tar, unzip et nginx..."
apt install -y curl tar unzip nginx

# Vérification de l'installation des dépendances de base
if command -v curl &> /dev/null && command -v tar &> /dev/null && command -v unzip &> /dev/null && command -v nginx &> /dev/null; then
  echo "Les dépendances de base ont été installées avec succès."
else
  echo "Une ou plusieurs installations ont échoué."
  exit 1
fi

# Ajouter le dépôt de PHP (si pas déjà ajouté)
echo "Ajout du dépôt PHP..."
add-apt-repository -y ppa:ondrej/php

# Mettre à jour les informations sur les paquets après l'ajout du dépôt PHP
apt update -y

# Installer PHP 8.3 et ses extensions nécessaires
echo "Installation de PHP 8.3 et des extensions nécessaires..."
apt install -y php8.3 php8.3-fpm php8.3-gd php8.3-mysql php8.3-mbstring php8.3-bcmath php8.3-xml php8.3-curl php8.3-zip php8.3-intl php8.3-sqlite3

# Vérification de l'installation de PHP et des extensions
if command -v php8.3 &> /dev/null && php8.3 -m | grep -q 'gd' && php8.3 -m | grep -q 'mysql' && php8.3 -m | grep -q 'mbstring' && php8.3 -m | grep -q 'bcmath' && php8.3 -m | grep -q 'xml' && php8.3 -m | grep -q 'curl' && php8.3 -m | grep -q 'zip' && php8.3 -m | grep -q 'intl' && php8.3 -m | grep -q 'sqlite3'; then
  echo "PHP 8.3 et toutes les extensions nécessaires ont été installés avec succès."
else
  echo "Une ou plusieurs installations ont échoué."
  exit 1
fi

# Optionnel : Afficher la version de PHP installée
php -v

echo "Les dépendances ont été installées. Nginx et PHP sont maintenant prêts à être configurés."

# Créer le répertoire /var/www/pelican et y accéder
echo "Création du répertoire /var/www/pelican..."
mkdir -p /var/www/pelican

# Passer dans le répertoire créé
cd /var/www/pelican
echo "Vous êtes maintenant dans le répertoire /var/www/pelican."

# Télécharger et extraire le fichier panel.tar.gz depuis GitHub
echo "Téléchargement et extraction de panel.tar.gz depuis GitHub..."
curl -L https://github.com/pelican-dev/panel/releases/latest/download/panel.tar.gz | sudo tar -xzv -C /var/www/pelican

# Installer Composer (gestionnaire de dépendances PHP)
echo "Installation de Composer..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Exécuter composer install pour installer les dépendances PHP (sans les dépendances de développement)
echo "Exécution de 'composer install' pour installer les dépendances PHP..."
sudo composer install --no-dev --optimize-autoloader

# Message d'instruction pour démarrer Nginx
echo "Nginx n'a pas encore démarré. Pour démarrer nginx, utilisez la commande suivante :"
echo "sudo systemctl start nginx"
echo "Pour activer nginx au démarrage, utilisez :"
echo "sudo systemctl enable nginx"

# Fin du script
echo "Le script a terminé l'installation des dépendances, la création du répertoire /var/www/pelican, l'extraction du panel.tar.gz, et l'installation des dépendances via Composer."
