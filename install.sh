#!/bin/bash

export DestBucketName=MyFavDestinationBucket
export DestRegion=us-west-2
export DestAccountId=11111111

export SourceBucketName=MyFavSourceBucket
export SourceLogBucketName=
export SourceRegion=us-east-1

echo "Creating Destination bucket"
aws cloudformation create-stack --stack-name S3BucketReplDestination \
--template-body file://s3destinationbucket.yml \
--parameters ParameterKey=bucketName,ParameterValue=$DestBucketName \
ParameterKey=accountID,ParameterValue=$DestAccountId \
--region $DestRegion

echo "Waiting for Destination Stack to be created"

echo "NOT IMPLEMENTED"

echo "Creating Source bucket"
aws cloudformation create-stack --stack-name S3BucketReplSource \
--template-body file://s3sourcebucket.yml \
--parameters ParameterKey=bucketName,ParameterValue=$SourceBucketName \
ParameterKey=logBucketName,ParameterValue=$SourceLogBucketName \
ParameterKey=destinationBucketName,ParameterValue=$DestBucketName \
--capabilities CAPABILITY_IAM \
--region $SourceRegion



