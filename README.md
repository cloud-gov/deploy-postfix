# cloud.gov Postfix Deployment

This repo contains the source for the Bosh deployment manifest and deployment pipeline for the cloud.gov Postfix deployment.

## Rationale

cloud.gov requires a mail relay to send outbound mails from internal tooling.

## Architecture

This pipeline will deploy:

* Production
  * 1 mail relay
    * cg-provision will have allocated an IP (terraform_outputs.production_smtp_private_ip) and set up security groups with terraform.
    * The postfix deployment will be deployed to the tooling bosh.
    * Services will contact the postfix server and auth using SASL.
    * Mail will be relayed to the configured mail relay.

## Deployment

### cloud.gov

1. Create `production-postfix.yml`:

   ```shell
   cp bosh/secrets.example.yml /tmp/production-postfix.yml
   bosh int bosh/manifest.yml --vars-store /tmp/production-postfix.yml > /dev/null
   ```

   Replace all `XXX`es in `/tmp/production-postfix.yml` with proper values.  Then encrypt that file and upload it to S3.

1. Create cg-deploy-postfix.yml: copy ci/concourse-defaults.yml to cg-deploy-postfix.yml, edit the file and uncomment all the lines with `XXX`es in them, fill in proper values.  Be sure to upload the file to the concourse secrets bucket so that others can use it.
1. The pipeline under `ci/pipeline.yml` deploys to production:

   ```shell
   fly -t cloud-gov-govcloud sp -p deploy-postfix -c ci/pipeline.yml -l /tmp/cg-deploy-postfix.yml
   ```

### bosh-lite

To test the deployment out, you should be able to do this:

```shell
bosh int bosh/manifest.yml --vars-store /tmp/pfvars.yml > /tmp/pfmanifest.yml
bosh update-cloud-config bosh-lite-cloud-config.yml
bosh deploy -d postfix /tmp/pfmanifest.yml -l bosh/varsfiles/bosh-lite.yml -l /tmp/pfvars.yml
```

This assumes that the <https://github.com/cloud-gov/postfix-boshrelease> release has been created and uploaded already.  If you do not have that, then you will probably need to clone that repo, cd into it, and then `bosh create-release ; bosh upload-release` to get it there.
