#!/bin/bash

set -eux

spruce merge --prune terraform_outputs \
  postfix-config/varsfiles/${ENVIRONMENT}-terraform.yml \
  terraform-yaml/state.yml \
  terraform-secrets/ns.yml \
  >> terraform-secrets/terraform.yml

