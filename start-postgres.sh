#!/bin/bash
set -e

SSL_DIR="/docker-entrypoint-initdb.d/certs"

# Generate a self-signed SSL certificate for PostgreSQL if it doesn’t exist
if [ ! -f "${SSL_DIR}/server.crt" ]; then
  echo "Generating self-signed SSL certificate for PostgreSQL..."
  mkdir -p "${SSL_DIR}"
  openssl req -new -x509 -nodes -days 365 \
    -out ${SSL_DIR}/server.crt \
    -keyout ${SSL_DIR}/server.key \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

  # Correct permissions
  chmod 600 ${SSL_DIR}/server.key
  chown postgres:postgres ${SSL_DIR}/server.key ${SSL_DIR}/server.crt
fi

# Append SSL configuration
cat <<EOF >>"${PGDATA}/postgresql.conf"
ssl = on
ssl_cert_file = '${SSL_DIR}/server.crt'
ssl_key_file = '${SSL_DIR}/server.key'
EOF

echo "hostssl all all 0.0.0.0/0 md5" >>"${PGDATA}/pg_hba.conf"
