resource "aws_ssm_parameter" "postgres_db" {
  name  = "/wpoms/POSTGRES_DB"
  type  = "String"
  value = "testdb"

  tags = {
    Project = "wpoms"
  }
}

resource "aws_ssm_parameter" "postgres_user" {
  name  = "/wpoms/POSTGRES_USER"
  type  = "String"
  value = "postgres"

  tags = {
    Project = "wpoms"
  }
}

resource "aws_ssm_parameter" "postgres_password" {
  name  = "/wpoms/POSTGRES_PASSWORD"
  type  = "SecureString"
  value = "1234"

  tags = {
    Project = "wpoms"
  }
}