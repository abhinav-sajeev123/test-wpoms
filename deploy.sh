#!/bin/bash
set -e

echo "Running deployment script..."

echo "Downloading docker-compose..."
aws s3 cp s3://$S3_BUCKET/docker-compose.yml docker-compose.yml

echo "Logging into ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

echo "Stopping old containers..."
docker compose down || true

echo "Pulling images..."
docker compose pull

echo "Starting new containers..."
docker compose up -d

echo "Deployment successful"