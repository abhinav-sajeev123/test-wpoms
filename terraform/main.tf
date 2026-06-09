terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

locals {
  repositories = [
    "wpoms-abhinav-frontend",
    "wpoms-abhinav-backend"
  ]
}

resource "aws_ecr_repository" "repos" {
  for_each = toset(local.repositories)

  name = each.value
}

output "frontend_repo_url" {
  value = aws_ecr_repository.repos["wpoms-abhinav-frontend"].repository_url
}

output "backend_repo_url" {
  value = aws_ecr_repository.repos["wpoms-abhinav-backend"].repository_url
}

resource "aws_security_group" "ssh" {
  name        = "terraform-ssh"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server" {
  ami           = "ami-0db56f446d44f2f09"
  instance_type = "t3.micro"
  key_name      = "wpoms"

   vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "terraform-ec2"
  }
}