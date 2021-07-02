terraform {
  required_version = ">= 0.12.26"
}

provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "all" {}
resource "aws_autoscaling_group" "tf-asg" {
  launch_configuration = aws_launch_configuration.tf-launchconfig.id
  availability_zones   = data.aws_availability_zones.all.names
  min_size = 2
  max_size = 10
  load_balancers    = [aws_elb.tf-elb.name]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-deployment"
    propagate_at_launch = true
  }
}
resource "aws_launch_configuration" "tf-launchconfig" {
  # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type in us-east-2
  image_id        = var.community_ami
  instance_type   = var.instace_type
  security_groups = [aws_security_group.asg-instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World! This is a loal balanced webserver deployed by Terraform. (please check https://github.com/gondaljutt/learn-terraform for more usefull info)" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
    delete_on_termination = "true"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "asg-instance" {
  name = "tf-asg-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = var.open-for-public
  }
}


resource "aws_elb" "tf-elb" {
  name               = "terraform-asg-elb"
  security_groups    = [aws_security_group.asg-tf-elb-sg.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}
resource "aws_security_group" "asg-tf-elb-sg" {
  name = "terraform-elb-secgroup"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.open-for-public
  }
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = var.open-for-public
  }
}
