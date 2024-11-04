provider "aws" {
  region = "us-east-1"  # Update this to your assigned AWS Academy region if different

  # Using EC2 instance role if available
  profile = "danish"
  
}


resource "aws_s3_bucket" "web_bucket" {
  bucket = "web-bucket-danish1"  # Name the bucket as "web-bucket-<your_name>"
  
  versioning {
    enabled = true  # Enable versioning for file version management
  }
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-${var.name}"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80  # Allow HTTP inbound traffic on port 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0  # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id  # Latest Ubuntu AMI
  instance_type          = "t2.micro"  # Instance type as per assignment
  associate_public_ip_address = true  # Enable public IP for internet access
  security_groups        = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "web-server-instance-danish"  # Tagging the instance
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]  # Canonical (Ubuntu) account ID
}