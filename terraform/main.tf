terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#################################################
# Default VPC
#################################################

data "aws_vpc" "default" {
  default = true
}

#################################################
# Default subnet in us-east-1a
#################################################

data "aws_subnet" "k8s" {
  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

#################################################
# Debian 13 AMI
#################################################

data "aws_ami" "debian13" {
  most_recent = true

  owners = ["136693071363"]

  filter {
    name   = "name"
    values = ["debian-13-amd64-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#################################################
# Security Group
#################################################

resource "aws_security_group" "k8s_nodes" {
  name        = "k8s-nodes-sg"
  description = "Kubernetes nodes"
  vpc_id      = data.aws_vpc.default.id

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

  ingress {
    description = "Kubernetes NodePort Services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "All node-to-node traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-nodes-sg"
  }
}

#################################################
# Controller Node
#################################################

resource "aws_instance" "controller" {
  ami                         = data.aws_ami.debian13.id
  instance_type               = "t3.large"
  key_name                    = "vockey"
  subnet_id                   = data.aws_subnet.k8s.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.k8s_nodes.id
  ]

  tags = {
    Name = "k8s-controller"
  }
}

#################################################
# Worker Node
#################################################

resource "aws_instance" "worker1" {
  ami                         = data.aws_ami.debian13.id
  instance_type               = "t3.large"
  key_name                    = "vockey"
  subnet_id                   = data.aws_subnet.k8s.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.k8s_nodes.id
  ]

  tags = {
    Name = "k8s-worker1"
  }
}

#################################################
# Outputs
#################################################

output "controller_public_ip" {
  value = aws_instance.controller.public_ip
}

output "controller_private_ip" {
  value = aws_instance.controller.private_ip
}

output "worker1_public_ip" {
  value = aws_instance.worker1.public_ip
}

output "worker1_private_ip" {
  value = aws_instance.worker1.private_ip
}

output "subnet_used" {
  value = data.aws_subnet.k8s.id
}

output "debian_ami" {
  value = data.aws_ami.debian13.id
}

