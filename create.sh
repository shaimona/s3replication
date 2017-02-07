#!/bin/bash

export DestBucketName=myfavdestinationbucket
export DestRegion=us-west-2
export DestAccountId=109558624488
export DestStackName=S3BucketReplDestination
export DestProfile=prod

export SourceBucketName=myfavsourcebucket
export SourceLogBucketName=myfavlogbucket
export SourceRegion=us-east-1
export SourceProfile=dev

# Import shared functions
source common.sh

set +e
echo "Creating Destination bucket"
aws cloudformation create-stack --stack-name ${DestStackName} \
--template-body file://s3destinationbucket.yml \
--parameters ParameterKey=bucketName,ParameterValue=${DestBucketName} \
ParameterKey=accountID,ParameterValue=${DestAccountId} \
--region ${DestRegion} \
--profile ${DestProfile}

# Snatch the return code from the command above
RC=$?

# Check the status, spin until it completes
set -e
checkCFStatus ${DestStackName} ${DestProfile}

set +e
echo "Creating Source bucket"
aws cloudformation create-stack --stack-name S3BucketReplSource \
--template-body file://s3sourcebucket.yml \
--parameters ParameterKey=bucketName,ParameterValue=${SourceBucketName} \
ParameterKey=logBucketName,ParameterValue=${SourceLogBucketName} \
ParameterKey=destinationBucketName,ParameterValue=${DestBucketName} \
--capabilities CAPABILITY_NAMED_IAM \
--region ${SourceRegion} \
--profile ${SourceProfile}

# Snatch the return code from the command above
RC=$?

# Check the status, spin until it completes
set -e
checkCFStatus ${SourceStackName} ${SourceProfile}