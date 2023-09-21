#! /bin/bash
export AWS_PROFILE=sushi-order-system

BUCKET_NAME=$1

aws s3api create-bucket \
--bucket ${BUCKET_NAME} \
--acl private \
--create-bucket-configuration LocationConstraint=ap-northeast-1

aws s3api put-bucket-versioning \
--bucket ${BUCKET_NAME} \
--versioning-configuration Status=Enabled

aws s3api put-public-access-block \
--bucket ${BUCKET_NAME} \
--public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

unset AWS_PROFILE