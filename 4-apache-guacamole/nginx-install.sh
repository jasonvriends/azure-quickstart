#!/bin/bash

# Verify the script is being called from entrypoint.sh
if [ -z "$guacamole_version" ] || [ -z "$guacamole_location" ] || [ -z "$script_path" ]; then
    echo "$(date "+%F %T") nginx-install must be called via entrypoint.sh."
    exit 1
fi

# Update package lists
apt-get update

# Install Nginx
apt-get install nginx -y

# Configure Nginx

## Disable the default server block
rm /etc/nginx/sites-enabled/default

## Create server block with Apache Guacamole
echo "server {" > /etc/nginx/sites-available/apache-guacamole
echo " " >> /etc/nginx/sites-available/apache-guacamole
echo "    listen 80 default_server;" >> /etc/nginx/sites-available/apache-guacamole
echo "    listen [::]:80 default_server;" >> /etc/nginx/sites-available/apache-guacamole
echo "    root /var/www/html;" >> /etc/nginx/sites-available/apache-guacamole
echo "    index index.html index.htm index.nginx-debian.html;" >> /etc/nginx/sites-available/apache-guacamole
echo "    server_name \$hostname;" >> /etc/nginx/sites-available/apache-guacamole
echo "    location / {" >> /etc/nginx/sites-available/apache-guacamole
echo "        proxy_pass http://localhost:8080/guacamole/;" >> /etc/nginx/sites-available/apache-guacamole
echo "        proxy_buffering off;" >> /etc/nginx/sites-available/apache-guacamole
echo "        proxy_http_version 1.1;" >> /etc/nginx/sites-available/apache-guacamole
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/sites-available/apache-guacamole
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/sites-available/apache-guacamole
echo "        proxy_set_header Connection \$http_connection;" >> /etc/nginx/sites-available/apache-guacamole
echo "        access_log off;" >> /etc/nginx/sites-available/apache-guacamole
echo "    }" >> /etc/nginx/sites-available/apache-guacamole
echo " " >> /etc/nginx/sites-available/apache-guacamole
echo "}" >> /etc/nginx/sites-available/apache-guacamole

## Activate server block for Apache Guacamole
ln -s /etc/nginx/sites-available/apache-guacamole /etc/nginx/sites-enabled/apache-guacamole

# Restart Nginx
systemctl restart nginx