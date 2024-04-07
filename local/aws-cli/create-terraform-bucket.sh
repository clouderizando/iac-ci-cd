#!/bin/bash

bucket_name="clouderizando-iac-ci-cd"
region="us-east-1"
project="IaC-CI-CD"

# Create a bucket for Terraform states
aws s3api create-bucket --bucket $bucket_name --region $region > /dev/null
aws s3api put-bucket-tagging --bucket $bucket_name --tagging "TagSet=[{Key=Project,Value=$project}]"

echo "Bucket created successfully"
