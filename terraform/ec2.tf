resource "aws_key_pair" "lab_key" {
  key_name   = "abhinav-key"
  public_key = file("C:/Users/abhinav sajeev/.ssh/lab_key.pub")
}

data "aws_ami" "al2023" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "server" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.lab_key.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.ssh.id]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "terraform-ec2"
  }
}