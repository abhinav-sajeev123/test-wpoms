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