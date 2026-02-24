provider "aws" {
  region = "eu-north-1"
}

# Security Group
resource "aws_security_group" "devops_sg" {
  name        = "devops-security-group"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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

# EC2 Instance
resource "aws_instance" "devops_server" {
    ami           = "ami-0c33fcb753a7176f6"  # Ubuntu 22.04 in eu-north-1  
    instance_type = "t3.micro"
    key_name      = "devops1-key"

  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "terraform-devops-server"
  }
}

# Output public IP
output "public_ip" {
  value = aws_instance.devops_server.public_ip
}