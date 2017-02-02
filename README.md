## Cross-region Cross-account S3 Bucket Replication Configuration Guide

This document serves to outline the steps necessary to implement bucket replication.

__Features delivered__
- Encryption-at-rest
- Object replication
- ACL replication
- Server Access Logging for Source bucket

__Features remaining__
- "Installation" Bash script
- MFA-delete
- Proof-of-concept Python script showing how to set required ACL entry listed in "Caveats" section

__Caveats__
- Uploaded objects must have an explicit ACL entry created which grants "Open/Download" and "View Permissions" to the Destination Account's "root" user

__Resources delivered__
- CloudFormation templates (one per bucket)

### Steps to implement (WIP)
1. Identify your "source" and "destination" AWS Account IDs.
2. ..to be continued..
