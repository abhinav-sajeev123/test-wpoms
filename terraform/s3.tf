resource "aws_s3_bucket" "deploy_files" {
  bucket = "wpoms-abhinav-deploy-files"

  tags = {
    Name = "wpoms-abhinav-files"
  }
}