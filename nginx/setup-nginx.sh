#!/bin/bash

set -e

# Define the directory for SSL certificates
CERTS_DIR="/etc/nginx/certs"
mkdir -p "${CERTS_DIR}"

# Generate a self-signed SSL certificate if it doesn't exist
if [ ! -f "${CERTS_DIR}/selfsigned.crt" ]; then
  echo "Generating self-signed SSL certificate for Nginx..."
  openssl req -new -x509 -days 365 -nodes \
    -out "${CERTS_DIR}/selfsigned.crt" -keyout "${CERTS_DIR}/selfsigned.key" \
    -subj "/CN=localhost" || {
    echo "SSL certificate generation failed."
    exit 1
  }
else
  echo "SSL certificate already exists, skipping generation."
fi

# Write the nginx configuration directly to its configuration directory
cat <<EOF >/etc/nginx/nginx.conf
worker_processes 1;

events {
  worker_connections 1024;
}

http {
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  client_max_body_size 1024M;

  server {
    listen 80;
    return 301 https://\$host\$request_uri;
  }

  server {
    listen 443 ssl;
    ssl_certificate /etc/nginx/certs/selfsigned.crt;
    ssl_certificate_key /etc/nginx/certs/selfsigned.key;

    location / {
      proxy_pass http://${SEMAPHORE_CONTAINER}:${SEMAPHORE_PORT};
      proxy_set_header Host \$host;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto \$scheme;
    }
  }
}
EOF

echo "Nginx setup completed. Starting Nginx..."
