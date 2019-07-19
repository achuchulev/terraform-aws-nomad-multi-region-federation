#!/usr/bin/env bash

# Create cron job to check and renew public certificate on expiration
echo "Create cron job to check and renew public certificate on expiration...."

crontab <<EOF
0 12 * * * /usr/bin/certbot renew --quiet
EOF