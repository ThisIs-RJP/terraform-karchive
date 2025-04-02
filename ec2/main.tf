## Variables

variable "access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS secret access key"
  type        = string
  sensitive   = true
}

### 

provider "aws" {
  region     = "ap-northeast-3"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_key_pair" "my_key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "ssh_access" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

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

resource "aws_instance" "karchive_ec2" {
  ami             = "ami-053e5b2b49d1b2a82"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.ssh_access.name]

  tags = {
    Name = "Karchive-EC2"
  }
}

output "public_ip" {
  value     = aws_instance.my_ec2.public_ip
  sensitive = true
}
