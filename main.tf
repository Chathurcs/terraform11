provider "aws" {
  region                   = "us-east-1"
  # shared_credentials_files = ["~/.aws/credentials"]
  profile = "tfuser"

}

resource "aws_instance" "tfvm1" {
  ami                    = "ami-0bb84b8ffd87024d8"
  instance_type          = "t2.micro"
  key_name               = "vm1key"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.sg1.id]
  depends_on             = [aws_security_group.sg1]

  tags = {
    name = "test-vm1"
  }
}

resource "aws_security_group" "sg1" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic and all outbound traffic"


  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}