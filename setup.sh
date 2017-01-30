#!/bin/sh
DEST_DYNDNS="/opt/usr/bin/dyndns.sh"
SECRETS_FILE="/opt/var/dyndns_secrets"

if [ ! -L ${DEST_DYNDNS} ]; then
  echo "Creating symlink for ${DEST_DYNDNS}"
  ln -s "$(pwd)/dyndns.sh" "${DEST_DYNDNS}"
fi

if [ ! -f ${SECRETS_FILE} ]; then 
  echo "Copy secrets file with DDNS_DOMAIN, DDNS_HOSTNAME, DDNS_USERNAME, and DDNS_PASSWORD to ${SECRETS_FILE}"
fi
