#!/bin/bash
echo "Creating S3 bucket"
awslocal s3api create-bucket --bucket foodly-bucket
