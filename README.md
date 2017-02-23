## Cross-region Cross-account S3 Bucket Replication Configuration Guide

This document serves to outline the steps necessary to implement bucket replication.

In short, a shell script is responsible for calling Cloudformation and creating the S3 buckets and applying policies. Additionally, a role is created to facilitate replication (`S3ReplicationRole`).

__Features delivered__
- Encryption-at-rest
- Object replication
- Server Access Logging for Source bucket

__Features remaining__
- MFA-delete

__Caveats__
- Log bucket is optimistically created. This is an artifact of testing and `s3sourcebucket.yml` should be modified to remove this step if it is not desired.
- Objects must have an explicit ACL entry created which grants "Open/Download" and "View Permissions" to the Destination Account's "root" user. This requirement goes away once S3 Cross-Region Replication, a Beta feature, is enabled for your account or promoted to GA status.

### Steps to implement

1. Copy `env.sh.SAMPLE` to `env.sh`
2. Edit `env.sh` to reflect your environment (profiles, bucket names, account IDs, etc)
3. Run `./create.sh` to create the required buckets and policies
4. Upload an object into the Source bucket. It can take up to 15 minutes for initial replication.

Please note that the `env.sh` is simply a convenience. As long as the environment variables are defined somehow then the import can be removed from `create.sh`.
