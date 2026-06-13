output "frontend_repo_url" {
  value = aws_ecr_repository.repos["wpoms-abhinav-frontend"].repository_url
}

output "backend_repo_url" {
  value = aws_ecr_repository.repos["wpoms-abhinav-backend"].repository_url
}

output "public_ip" {
  value = aws_instance.server.public_ip
}

output "public_dns" {
  value = aws_instance.server.public_dns
}