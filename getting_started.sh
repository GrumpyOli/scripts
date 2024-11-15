#!/bin/bash

# Beautiful header
echo -e "\n"
echo "==============================================="
echo -e "\033[1;35m     Pelican Panel Dependency Installer      \033[0m"
echo -e "\033[1;33m  This script will install all dependencies    \033[0m"
echo -e "\033[1;33m   needed for the Pelican Panel setup!        \033[0m"
echo "==============================================="
echo -e "\n"

# Update package list
echo "Updating package list..."
sudo apt update

# Install required tools
echo "Installing tar, unzip, MariaDB Client, and MariaDB Server..."
sudo apt install -y tar unzip mariadb-client mariadb-server

# Add PHP repository
echo "Adding PHP repository..."
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update

# Install PHP 8.3 and extensions
echo "Installing PHP 8.3 and extensions..."
sudo apt install -y php8.3 php8.3-fpm php8.3-gd php8.3-mysql php8.3-mbstring php8.3-bcmath php8.3-xml php8.3-curl php8.3-zip php8.3-intl php8.3-sqlite3

# Create the /var/www/pelican folder
echo "Creating /var/www/pelican folder..."
sudo mkdir -p /var/www/pelican

# Navigate to the folder
cd /var/www/pelican

# Download and extract panel.tar.gz
echo "Downloading and extracting panel.tar.gz..."
curl -L https://github.com/pelican-dev/panel/releases/latest/download/panel.tar.gz | sudo tar -xzv -C /var/www/pelican

# Install Composer
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Run composer install
echo "Running composer install..."
sudo composer install --no-dev --optimize-autoloader

# Beautiful installation complete message
echo -e "\n"
echo "==============================================="
echo -e "\033[1;32m       Installation Complete!              \033[0m"
echo -e "\033[1;34m   Your system is now ready to rock and roll!  \033[0m"
echo -e "===============================================\n"
