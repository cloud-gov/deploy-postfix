## cloud.gov Bosh Postfix Deployment Manifests and Concourse pipeline

This repo contains the source for the Bosh deployment manifest and deployment pipeline for the cloud.gov Postfix deployment.

### Rationale
cloud.gov requires a mail relay to send outbound mails from internal tooling.

### Architecture
This pipeline will deploy:
* Staging
  * 1 mail relay
* Production
  * 1 mail relay

### Deployment
The pipeline under `ci/pipeline.yml` deploys to staging, generates a non-redacted diff against production configuration, and will manually allow a production push.  It will run smoke tests against production every 10 minutes, and send the notifications to Slack.

To customize this release for a deployment, [BOSH Operations Files](https://bosh.io/docs/cli-ops-files.html) are used to change the YAML to match the deployment.  These files replace variables given via [Bosh Variables](https://bosh.io/docs/cli-int.html) and `terraform-secrets.sh`.  To change the example record to the record of your choice:

