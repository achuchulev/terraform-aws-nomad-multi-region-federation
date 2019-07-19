#!/bin/bash

# Configure nginx
echo "Configuring nginx...."

# Stop nginx service
systemctl stop nginx.service

# Remove default conf of nginx
[ -f /etc/nginx/sites-available/default ] && {
 rm -fr /etc/nginx/sites-available/default
}

# Copy our nginx conf
cat <<EOF > /etc/nginx/sites-available/default
server {

    listen 80 default_server;
    server_name localhost;

    location / {
        proxy_pass https://nomad_backend;
        proxy_ssl_verify on;
        proxy_ssl_trusted_certificate /home/ubuntu/nomad/ssl/nomad-ca.pem;
        proxy_ssl_certificate /home/ubuntu/nomad/ssl/cli.pem;
        proxy_ssl_certificate_key /home/ubuntu/nomad/ssl/cli-key.pem;
        proxy_ssl_name server.$1.nomad; 
    }
}
EOF