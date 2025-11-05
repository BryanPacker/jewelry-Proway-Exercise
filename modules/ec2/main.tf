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
  owners = ["099720109477"]
}

# cidr_block       = "10.0.1.0/16"
#  region = "us-east-1"

#  tags = {
#    Name = "jewelry-vpc-bryan"
#  }
#}

resource "aws_subnet" "jewerly_sn_bryan" {
  vpc_id            = "vpc-06786ee7f7a163059"
  cidr_block        = "172.30.169.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "jewerly-sn-bryan"
  }
}
resource "aws_security_group" "jewerly_sg_bryan" {
  vpc_id      = "vpc-06786ee7f7a163059"
  
    # Regra de entrada - HTTP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regra de saída - Permite tudo
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
  tags = {
    Name = "jewerly-bryan-sg"
  }
}

resource "aws_instance" "jewerly_instance_bryan" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.jewerly_sg_bryan.id]
  subnet_id                   = aws_subnet.jewerly_sn_bryan.id
  associate_public_ip_address = true
  user_data_base64            = base64encode(<<-EOF
    #!/bin/bash
    apt update
    apt install -y docker.io git build-essential
    systemctl start docker
    systemctl enable docker
    docker container stop jewelry-app 2> /dev/null
    cd /home
    rm -rf jewelry-Proway-Exercise/
    git clone https://github.com/BryanPacker/jewelry-Proway-Exercise.git
    cd jewelry-Proway-Exercise/
    make docker-run
   EOF
  )
  tags = {
    Name = "jewerly-instance-bryan"
  }
}


