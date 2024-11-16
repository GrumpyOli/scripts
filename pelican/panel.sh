#!/bin/bash

# Starting installation process
echo -e "\n"
echo "==============================================="
echo "    Starting Pelican Panel Dependency Installer "
echo "==============================================="
echo -e "\n"

# Update package list
sudo apt update -qq

# Install required tools
sudo apt install -y -qq tar unzip mariadb-client mariadb-server

# Add PHP repository
sudo apt install -y -qq software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update -qq

# Install PHP 8.3 and extensions
sudo apt install -y -qq php8.3 php8.3-fpm php8.3-gd php8.3-mysql php8.3-mbstring php8.3-bcmath php8.3-xml php8.3-curl php8.3-zip php8.3-intl php8.3-sqlite3

# Create the /var/www/pelican folder
sudo mkdir -p /var/www/pelican

# Navigate to the folder
cd /var/www/pelican

# Download and extract panel.tar.gz
curl -L -s https://github.com/pelican-dev/panel/releases/latest/download/panel.tar.gz | sudo tar -xz -C /var/www/pelican

# Install Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Run composer install
sudo composer install --quiet --no-dev --optimize-autoloader

# Install NGINX
sudo apt install -y -qq nginx

# Ask the user if they want to keep their existing NGINX configuration
read -p "Do you want to keep your existing NGINX configuration? (y/n): " KEEP_CONFIG

if [[ "$KEEP_CONFIG" == "n" || "$KEEP_CONFIG" == "N" ]]; then
    # Remove the default nginx configuration
    sudo rm /etc/nginx/sites-enabled/default

    curl -L https://raw.githubusercontent.com/GrumpyOli/scripts/refs/heads/main/pelican/nginx/http/pelican.conf -o /etc/nginx/sites-available/pelican.conf

    # Enable the new configuration by creating a symlink (only if it was removed or doesn't exist)
    sudo ln -s /etc/nginx/sites-available/pelican.conf /etc/nginx/sites-enabled/

    # Reload NGINX to apply the new configuration
    sudo systemctl reload nginx

    echo -e "\nNGINX configuration for $domain has been successfully set up."
else
    echo -e "\nKeeping the existing NGINX configuration."
fi
