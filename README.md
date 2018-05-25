## cloud.gov Bosh Postfix Deployment Manifests and Concourse pipeline

This repo contains the source for the Bosh deployment manifest and deployment pipeline for the cloud.gov Postfix deployment.

### Rationale
cloud.gov requires a mail relay to send outbound mails from internal tooling.

### Architecture
This pipeline will deploy:
* Production
  * 1 mail relay
    * cg-provision will have allocated an IP (terraform_outputs.production_smtp_private_ip) and set up security groups with terraform.
    * The postfix deployment will be deployed to the tooling bosh. 
    * Services will contact the postfix server and auth using SASL.
    * Mail will be relayed to the configured mail relay.

### Deployment
Copy the bosh/secrets.example.yml file to production-postfix.yml and fill in the values with how you want it configured.  Then encrypt it and upload it to s3.

The pipeline under `ci/pipeline.yml` deploys to production.

To customize this release for a deployment, [BOSH Operations Files](https://bosh.io/docs/cli-ops-files.html) are used to change the YAML to match the deployment.  These files replace variables given via [Bosh Variables](https://bosh.io/docs/cli-int.html) and `terraform-secrets.sh`.

