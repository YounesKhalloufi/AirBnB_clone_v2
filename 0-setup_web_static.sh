#!/usr/bin/env bash
# a Bash script that sets up your web servers for the deployment of web_static

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    sudo apt-get update
    sudo apt-get -y install nginx
fi

# Create necessary directories if they don't exist
sudo mkdir -p /data/web_static/{releases/test,shared}

# Create a fake HTML file
echo "Fake Content" | sudo tee /data/web_static/releases/test/index.html > /dev/null

# Create or recreate the symbolic link
sudo rm -f /data/web_static/current
sudo ln -s /data/web_static/releases/test /data/web_static/current

# Give ownership of the /data/ folder to the ubuntu user and group recursively
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
nginx_config="/etc/nginx/sites-available/default"

# Create a temporary Nginx configuration file
cat > /tmp/nginx_config <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location /hbnb_static/ {
        alias /data/web_static/current/;
    }

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Replace the Nginx configuration file with the temporary file
sudo mv /tmp/nginx_config "$nginx_config"

# Restart Nginx to apply changes
sudo service nginx restart

echo "Web server setup complete."
