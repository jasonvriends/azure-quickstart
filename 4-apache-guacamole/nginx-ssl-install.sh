#!/bin/bash

# Verify the script is being called from entrypoint.sh
if [ -z "$guacamole_version" ] || [ -z "$guacamole_location" ] || [ -z "$script_path" ]; then
    echo "$(date "+%F %T") nginx-ssl-install must be called via entrypoint.sh."
    exit 1
fi

# Read script arguments
while [ "$1" != "" ]; do
    case $1 in
        --help )                help
                                ;;
        --ssl-email )           shift 
                                ssl_email="$1"
                                ;;
        --ssl-domain )          shift 
                                ssl_domain="$1"
                                ;;
    esac
    shift
done

# Check for empty positional parameters
if [ -z "$ssl_email" ] || [ -z "$ssl_domain" ]; then
    exit 1
fi

# Certbot

## Update package lists
apt-get update

## Add Certbot repository
add-apt-repository ppa:certbot/certbot -y

## Update package lists
apt-get update

## Install Certbot
apt-get install python-certbot-nginx -y

# Nginx 

## Replace server block with Apache Guacamole
echo "server {" > /etc/nginx/sites-available/apache-guacamole
echo " " >> /etc/nginx/sites-available/apache-guacamole
echo "    listen 80 default_server;" >> /etc/nginx/sites-available/apache-guacamole
echo "    listen [::]:80 default_server;" >> /etc/nginx/sites-available/apache-guacamole
echo "    root /var/www/html;" >> /etc/nginx/sites-available/apache-guacamole
echo "    index index.html index.htm index.nginx-debian.html;" >> /etc/nginx/sites-available/apache-guacamole
echo "    server_name $ssl_domain;" >> /etc/nginx/sites-available/apache-guacamole
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

## Stop Nginx
systemctl stop nginx

## Generate and Install a Let's Encrypt SSL certificate for Nginx
certbot --nginx -n --email "$ssl_email" --domain "$ssl_domain" --agree-tos --redirect --hsts

## Start Nginx
systemctl start nginx