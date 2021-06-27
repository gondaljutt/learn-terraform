terraform {
  required_version = ">= 0.12.26"
}
provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "tf-ec2" {
  ami                    = var.community_ami
  instance_type          = var.instace_type
  vpc_security_group_ids = [aws_security_group.tf-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World! This is a webserver deployed by Terraform. (please check https://github.com/gondaljutt/learn-terraform for more usefull info)" > index.html
              nohup busybox httpd -f -p "${var.server_http_port}" &
              EOF
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
    delete_on_termination = "true"
  }
  tags = {
    Name = "terraform-learn-ec2"
  }
}

resource "aws_security_group" "tf-sg" {
  name = "ec2-tf-secgroup"
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.close-for-public
  }
  ingress {
    from_port   = var.server_http_port
    to_port     = var.server_http_port
    protocol    = "tcp"
    cidr_blocks = var.open-for-public
  }
  ingress {
    from_port   = var.server_https_port
    to_port     = var.server_https_port
    protocol    = "tcp"
    cidr_blocks = var.open-for-public
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.open-for-public
  }
}
