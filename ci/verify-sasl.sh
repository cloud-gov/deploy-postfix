#!/bin/bash

set -eux

SMTP_IP=$(spruce json ${STATEFILE}/state.yml | jq -r ".terraform_outputs.production_smtp_private_ip")

BASE64_USERNAME=$(echo -n "${USERNAME}" | base64)
BASE64_PASSWORD=$(echo -n "${PASSWORD}" | base64)

# Confirm bad username / password is denied
echo -e "AUTH LOGIN\ntest\ntest\nQUIT" | openssl s_client -starttls smtp -crlf -quiet -connect "${SMTP_IP}:25" | grep ^535

# Config good username / password is allowed
echo -e "AUTH LOGIN\n${BASE64_USERNAME}\n${BASE64_PASSWORD}\nQUIT" | openssl s_client -starttls smtp -crlf -quiet -connect "${SMTP_IP}:25" | grep ^235
