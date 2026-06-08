resource "aws_security_group" "nat" {
  name        = "nat-sg"
  description = "NAT Instance SG"
  vpc_id      = aws_vpc.sandbox.id

  tags = {
    Name = "nat-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "nat_vpc" {
  security_group_id = aws_security_group.nat.id

  description = "Allow traffic from VPC"

  ip_protocol = "-1"

  cidr_ipv4 = aws_vpc.sandbox.cidr_block
}


resource "aws_vpc_security_group_ingress_rule" "nat_ssh" {
  security_group_id = aws_security_group.nat.id

  description = "Allow SSH from my IP"

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  cidr_ipv4 = "95.145.193.210/32"
}

resource "aws_vpc_security_group_egress_rule" "nat_all" {
  security_group_id = aws_security_group.nat.id
  description       = "Allow access to public internet"

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}