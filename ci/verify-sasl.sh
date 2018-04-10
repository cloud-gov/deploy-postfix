#!/bin/bash

set -eux

SMTP_IP=$(spruce json terraform-yaml/state.yml | jq -r ".terraform_outputs.${ENVIRONMENT}_smtp_private_ip")

# Requires STARTTLS to be active.
# Requires the cert to be trusted by the host that this is run on.
echo -e "AUTH LOGIN\ntest\ntest\nQUIT" | openssl s_client -starttls smtp -crlf -quiet -connect "${SMTP_IP}:25" | grep ^334
