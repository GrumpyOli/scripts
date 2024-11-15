#!/bin/bash

# Install Nginx
sudo apt update
sudo apt install -y nginx
echo "Nginx installed successfully."

# Remove the default Nginx configuration file if it exists
sudo rm -f /etc/nginx/sites-enabled/default
echo "Default Nginx configuration removed."

# Check if pelican.conf already exists in /etc/nginx/sites-available
if [ ! -f /etc/nginx/sites-available/pelican.conf ]; then

    # Download the pelican.conf file and place it in /etc/nginx/sites-available
    curl -o /etc/nginx/sites-available/pelican.conf https://raw.githubusercontent.com/GrumpyOli/scripts/refs/heads/main/pelican/nginx/pelican_http.conf
    echo "pelican.conf downloaded successfully."

    # Create a symbolic link in /etc/nginx/sites-enabled
    sudo ln -s /etc/nginx/sites-available/pelican.conf /etc/nginx/sites-enabled/pelican.conf
    echo "Symbolic link created successfully."

else
    echo "pelican.conf already exists. Skipping download."
fi

# Enable the Nginx service
sudo systemctl enable nginx
echo "Nginx service enabled successfully."

# Start the Nginx service
sudo systemctl restart nginx
echo "Nginx service started successfully."

cd /var/www/pelican
sudo chmod -R 755 storage/* bootstrap/cache/
sudo chown -R www-data:www-data /var/www/pelican

sudo php artisan p:environment:setup

echo "Script completed successfully."
