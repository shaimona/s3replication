## Cross-region Cross-account S3 Bucket Replication Configuration Guide

This document serves to outline the steps necessary to implement bucket replication.

__Features delivered__
- Encryption-at-rest
- Object replication
- Server Access Logging for Source bucket

__Features remaining__
- MFA-delete

__Caveats__
- Uploaded objects must have an explicit ACL entry created which grants "Open/Download" and "View Permissions" to the Destination Account's "root" user

### Steps to implement

Note! It is recommended that you configure two [Named Profiles](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-multiple-profiles) to easily switch between accounts.

1. Copy `env.sh.SAMPLE` to `env.sh`
2. Edit `env.sh` to reflect your environment (profiles, bucket names, account IDs, etc)
3. Run `./create.sh` to create the required buckets and policies
4. Upload an object into the Source bucket. It can take up to 15 minutes for initial replication.
