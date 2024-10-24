#!/bin/sh

set -e

echo "Environment variables for Semaphore UI:"
env | grep SEMAPHORE

echo "Creating config.json file..."

# Create a `semaphore` directory in `/etc` if it does not exist
mkdir -p /etc/semaphore

# Generate a proper AES 256-bit key since the previous ones might be incorrect
ENCRYPTION_KEY=$(openssl rand -base64 32)

cat <<EOF >/etc/semaphore/config.json
{
  "postgres": {
    "host": "${SEMAPHORE_DB_HOST}",
    "port": "${SEMAPHORE_DB_PORT}",
    "user": "${SEMAPHORE_DB_USER}",
    "pass": "${SEMAPHORE_DB_PASS}",
    "name": "${SEMAPHORE_DB_NAME}",
    "sslmode": "require"
  },
  "dialect": "postgres",
  "port": "${SEMAPHORE_PORT}",
  "tmp_path": "${SEMAPHORE_PLAYBOOK_PATH}",
  "cookie_hash": "${SEMAPHORE_COOKIE_HASH}",
  "cookie_encryption": "${SEMAPHORE_COOKIE_ENCRYPTION}",
  "access_key_encryption": "${SEMAPHORE_ACCESS_KEY_ENCRYPTION}"
}
EOF

export PGPASSWORD="${SEMAPHORE_DB_PASS}"
until psql -h "${SEMAPHORE_DB_HOST}" -U "${SEMAPHORE_DB_USER}" -d "${SEMAPHORE_DB_NAME}" -c '\q' >/dev/null 2>&1; do
  echo >&2 "Postgres is unavailable - sleeping"
  sleep 1
done

echo >&2 "Postgres is up - executing command"

# Add admin user if it does not exist
semaphore user list | grep "${SEMAPHORE_ADMIN}" || semaphore user add --admin \
  --login "${SEMAPHORE_ADMIN}" \
  --name "${SEMAPHORE_ADMIN_NAME}" \
  --email "${SEMAPHORE_ADMIN_EMAIL}" \
  --password "${SEMAPHORE_ADMIN_PASSWORD}"

# Start Semaphore server in the background
semaphore server --config /etc/semaphore/config.json
