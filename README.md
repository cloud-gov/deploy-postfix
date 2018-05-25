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
## cloud.gov

Create production-postfix.yml:
```
cp bosh/secrets.example.yml /tmp/production-postfix.yml
bosh int bosh/manifest.yml --vars-store /tmp/production-postfix.yml > /dev/null
```
Replace all `XXX`es in `/tmp/production-postfix.yml` with proper values.  Then encrypt that file and upload it to s3.

The pipeline under `ci/pipeline.yml` deploys to production.

## bosh-lite

To test the deployment out, you should be able to do this:
```
bosh int bosh/manifest.yml --vars-store /tmp/pfvars.yml > /tmp/pfmanifest.yml
bosh update-cloud-config bosh-lite-cloud-config.yml
bosh deploy -d postfix /tmp/pfmanifest.yml -l bosh/varsfiles/bosh-lite.yml -l /tmp/pfvars.yml
```
