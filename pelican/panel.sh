#!/bin/bash

# Beautiful header
echo -e "\n"
echo "==============================================="
echo "     Pelican Panel Dependency Installer      "
echo "  This script will install all dependencies  "
echo "   needed for the Pelican Panel setup!       "
echo "==============================================="
echo -e "\n"

# Update package list
echo "Updating package list..."
sudo apt update

# Install required tools
echo "Installing tar, unzip, MariaDB Client, and MariaDB Server..."
sudo apt install -y -qq tar unzip mariadb-client mariadb-server

# Add PHP repository
echo "Adding PHP repository..."
sudo apt install -y -qq software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update

# Install PHP 8.3 and extensions
echo "Installing PHP 8.3 and extensions..."
sudo apt install -y -qq php8.3 php8.3-fpm php8.3-gd php8.3-mysql php8.3-mbstring php8.3-bcmath php8.3-xml php8.3-curl php8.3-zip php8.3-intl php8.3-sqlite3

# Create the /var/www/pelican folder
echo "Creating /var/www/pelican folder..."
sudo mkdir -p /var/www/pelican

# Navigate to the folder
cd /var/www/pelican

# Download and extract panel.tar.gz
echo "Downloading and extracting panel.tar.gz..."
curl -L -s https://github.com/pelican-dev/panel/releases/latest/download/panel.tar.gz | sudo tar -xzv -C /var/www/pelican

# Install Composer
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Run composer install
echo "Running composer install..."
sudo composer install --quiet --no-dev --optimize-autoloader