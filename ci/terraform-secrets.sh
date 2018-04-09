#!/bin/bash

set -eux

spruce merge --prune terraform_outputs \
  terraform-yaml/state.yml \
  >> terraform-secrets/terraform.yml

