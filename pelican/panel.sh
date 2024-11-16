#!/bin/bash

# Function to check if a file exists
file_exists() {
    if [ -e "$1" ]; then
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}

# Starting installation process
echo -e "\n"
echo "==============================================="
echo "    Starting Pelican Panel Dependency Installer "
echo "==============================================="
echo -e "\n"

# Update package list
sudo apt update -qq

# Install required tools
sudo apt install -y -qq tar unzip mariadb-client mariadb-server whiptail

# Add PHP repository
sudo apt install -y -qq software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update -qq

# Install PHP 8.3 and extensions
sudo apt install -y -qq php8.3 php8.3-fpm php8.3-gd php8.3-mysql php8.3-mbstring php8.3-bcmath php8.3-xml php8.3-curl php8.3-zip php8.3-intl php8.3-sqlite3

#Installing Redis
sudo curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

sudo apt update -y -qq
sudo apt install -y -qq redis-server

sudo systemctl enable --now redis-server

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

# Define NGINX configuration file path
NGINX_CONFIG="/etc/nginx/sites-available/pelican.conf"

# Check if the NGINX configuration file exists using the file_exists function
if file_exists "$NGINX_CONFIG"; then
    # If the file exists, skip creating the new config and keep the existing one
    echo -e "\nNGINX configuration file already exists. Keeping the current configuration."
else
    # If the file doesn't exist, proceed to set up the new configuration
    echo -e "\nNGINX configuration file doesn't exist. Applying new configuration..."

    # Remove the default nginx configuration
    sudo rm /etc/nginx/sites-enabled/default

    # Download the new configuration file
    curl -L https://raw.githubusercontent.com/GrumpyOli/scripts/refs/heads/main/pelican/nginx/http/pelican.conf -o /etc/nginx/sites-available/pelican.conf

    # Enable the new configuration by creating a symlink
    sudo ln -s /etc/nginx/sites-available/pelican.conf /etc/nginx/sites-enabled/

    # Reload NGINX to apply the new configuration
    sudo systemctl reload nginx

    echo -e "\nNGINX configuration has been successfully set up."
fi

#Installing MariaDB
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
sudo apt install -y mariadb-server

cd /var/www/pelican
sudo chmod -R 755 storage/* bootstrap/cache/
sudo chown -R www-data:www-data /var/www/pelican
sudo php artisan p:environment:setup
