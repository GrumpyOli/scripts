#!/bin/bash

# Define variables
DEFAULT_CONF="/etc/nginx/sites-enabled/default"
PEL_CONF="/etc/nginx/sites-available/pelican.conf"
PEL_CONF_URL="https://raw.githubusercontent.com/GrumpyOli/scripts/refs/heads/main/pelican/nginx/pelican_http.conf"
LINK_CONF="/etc/nginx/sites-enabled/pelican.conf"

# Remove the default Nginx configuration
if [ -f "$DEFAULT_CONF" ]; then
    echo "Removing the default Nginx configuration..."
    rm "$DEFAULT_CONF"
    echo "Default Nginx configuration removed."
else
    echo "Default Nginx configuration does not exist. Nothing to remove."
fi

# Download the pelican.conf file
echo "Downloading pelican.conf from $PEL_CONF_URL..."
if curl -o "$PEL_CONF" "$PEL_CONF_URL"; then
    echo "pelican.conf downloaded successfully to $PEL_CONF."
else
    echo "Failed to download pelican.conf. Please check the URL or network connection."
    exit 1
fi

# Create a symbolic link in sites-enabled
echo "Creating symbolic link for pelican.conf..."
if ln -s "$PEL_CONF" "$LINK_CONF"; then
    echo "Symbolic link created at $LINK_CONF."
else
    echo "Failed to create symbolic link. Check permissions or if the link already exists."
    exit 1
fi

# Enable and start the Nginx service
echo "Enabling Nginx service..."
if systemctl enable nginx; then
    echo "Nginx service enabled."
else
    echo "Failed to enable Nginx service."
    exit 1
fi

echo "Starting Nginx service..."
if systemctl start nginx; then
    echo "Nginx service started successfully."
else
    echo "Failed to start Nginx service. Check the configuration or logs for issues."
    exit 1
fi

echo "Script completed successfully."
