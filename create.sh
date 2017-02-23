#!/bin/bash

# Import configuration
source env.sh

# Import shared functions
source common.sh

# Format bucket names
export DestBucketName=acom-${BucketName}-${DestAccountId}-${DestRegion}
export SourceBucketName=acom-${BucketName}-${SourceAccountId}-${SourceRegion}

echo "Creating Destination bucket"

set +e
aws sts assume-role --role-arn ${DestRoleArn} \
  --role-session-name CreateDestinationBucket | \
    grep -w 'AccessKeyId\|SecretAccessKey\|SessionToken' | \
    awk '{print $2}' | sed 's/\"//g;s/\,//' > .awscre;\
    export AWS_ACCESS_KEY_ID=`sed -n '3p' .awscre`;\
    export AWS_SECRET_ACCESS_KEY=`sed -n '1p' .awscre`;\
    export AWS_SECURITY_TOKEN=`sed -n '2p' .awscre`;\
    rm .awscre

aws cloudformation create-stack --stack-name ${DestStackName} \
--template-body file://s3destinationbucket.yml \
--parameters ParameterKey=bucketName,ParameterValue=${DestBucketName} \
ParameterKey=accountID,ParameterValue=${SourceAccountId} \
--region ${DestRegion}

set -e

# Snatch the return code from the command above
RC=$?

# Check the status, spin until it completes
checkCFStatus ${DestStackName} ${DestRegion}

# Setup for the next user
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SECURITY_TOKEN

set +e

echo "Creating Source bucket"

aws sts assume-role --role-arn ${SourceRoleArn} \
  --role-session-name CreateSourceBucket | \
    grep -w 'AccessKeyId\|SecretAccessKey\|SessionToken' | \
    awk '{print $2}' | sed 's/\"//g;s/\,//' > .awscre;\
    export AWS_ACCESS_KEY_ID=`sed -n '3p' .awscre`;\
    export AWS_SECRET_ACCESS_KEY=`sed -n '1p' .awscre`;\
    export AWS_SECURITY_TOKEN=`sed -n '2p' .awscre`;\
    rm .awscre

aws cloudformation create-stack --stack-name ${SourceStackName} \
--template-body file://s3sourcebucket.yml \
--parameters ParameterKey=bucketName,ParameterValue=${SourceBucketName} \
ParameterKey=logBucketName,ParameterValue=${LogBucketName} \
ParameterKey=destinationBucketName,ParameterValue=${DestBucketName} \
--capabilities CAPABILITY_NAMED_IAM \
--region ${SourceRegion}

set -e

# Snatch the return code from the command above
RC=$?

# Check the status, spin until it completes
checkCFStatus ${SourceStackName} ${SourceRegion}

echo "Bucket creation completed"
