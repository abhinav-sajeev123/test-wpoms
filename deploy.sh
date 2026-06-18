#!/bin/bash
set -e

echo "Running deployment script..."

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

FRONTEND_REPOSITORY=wpoms-abhinav-frontend
BACKEND_REPOSITORY=wpoms-abhinav-backend
S3_BUCKET=wpoms-abhinav-deploy-files

echo "Downloading docker-compose..."
aws s3 cp s3://$S3_BUCKET/docker-compose.yml docker-compose.yml

echo "Fetching DB config from SSM..."
POSTGRES_DB=$(aws ssm get-parameter --name "/wpoms/POSTGRES_DB" --query "Parameter.Value" --output text)

POSTGRES_USER=$(aws ssm get-parameter --name "/wpoms/POSTGRES_USER" --query "Parameter.Value" --output text)

POSTGRES_PASSWORD=$(aws ssm get-parameter --name "/wpoms/POSTGRES_PASSWORD" --with-decryption --query "Parameter.Value" --output text)

echo "Logging into ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

echo "Stopping old containers..."
docker compose down || true

echo "Pulling images..."
docker compose pull

echo "Starting new containers..."
docker compose up -d

echo "Deployment successful"