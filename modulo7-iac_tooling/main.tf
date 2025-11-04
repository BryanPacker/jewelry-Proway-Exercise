terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "jewelry-vpc" {
  cidr_block       = "10.0.1.0/16"
  region = "us-east-1"

  tags = {
    Name = "jewelry-vpc-bryan"
  }
}

resource "aws_subnet" "jewelry-subnet" {
  vpc_id     = aws_vpc.jewelry-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "jewelry-subnet-bryan"
  }
}

resource "aws_security_group" "jewelry-sec-group" {
  name        = "jewelry-sg-bryan"
  vpc_id      = aws_vpc.jewelry-vpc.id
  tags = {
    Name = "jewelry-sec-group-bryan"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.jewelry-sec-group.id
  cidr_ipv4         = aws_vpc.jewelry-vpc.cidr_block
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jewelry-bryan" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = "true"
  security_groups = [ aws_security_group.jewelry-sec-group.id]
  subnet_id = aws_subnet.jewelry-subnet.id
  user-data = <<-EOF 

    #!/bin/bash
    apt update
    apt install -y docker.io git build-essential
    systemctl start docker
    systemctl enable docker
    docker container stop jewelry-app 2> /dev/null
    cd /home
    rm -rf proway-docker/
    git clone https://github.com/BryanPacker/jewelry-Proway-Exercise.git
    cd ./modulo7-iac_tooling
    make docker-run

  EOF

  tags = {
    Name = "jewelry-instance-bryan"
  }
} 

output "vm_public_ip" {
  value = aws_instance.jewelry-bryan.public_ip
}

output "app_url" {
  value = "http://${aws_instance.jewelry-bryan.public_ip}:8080"
}
