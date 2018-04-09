#!/bin/bash

set -eux

# Requires STARTTLS to be active.
# Requires the cert to be trusted by the host that this is run on.
echo -e "AUTH LOGIN\ntest\ntest\nQUIT" | openssl s_client -starttls smtp -crlf -quiet -connect 10.99.1.12:25 | grep ^334
