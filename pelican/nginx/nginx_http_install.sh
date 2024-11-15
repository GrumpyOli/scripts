#!/bin/bash

# Install Nginx
sudo apt update
sudo apt install -y nginx
echo "Nginx installed successfully."

# Remove the default Nginx configuration file if it exists
rm -f /etc/nginx/sites-enabled/default
echo "Default Nginx configuration removed."

rm -f /etc/nginx/sites-enabled/pelican.conf
echo "Old Pelican configuration removed."

# Download the pelican.conf file and place it in /etc/nginx/sites-available
curl -o /etc/nginx/sites-available/pelican.conf https://raw.githubusercontent.com/GrumpyOli/scripts/refs/heads/main/pelican/nginx/pelican_http.conf
echo "pelican.conf downloaded successfully."

# Create a symbolic link in /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/pelican.conf /etc/nginx/sites-enabled/pelican.conf
echo "Symbolic link created successfully."

# Enable the Nginx service
sudo systemctl enable nginx
echo "Nginx service enabled successfully."

# Start the Nginx service
sudo systemctl restart nginx
echo "Nginx service started successfully."

echo "Script completed successfully."
