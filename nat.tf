resource "aws_instance" "nat" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.nano"
  key_name      = "abbas"
  iam_instance_profile = aws_iam_instance_profile.nat_instance_profile.name

  subnet_id = aws_subnet.public[0].id

  vpc_security_group_ids = [
    aws_security_group.nat.id
  ]

  associate_public_ip_address = true

  source_dest_check = false

  user_data = <<-EOF
#!/bin/bash

sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

dnf install -y iptables-services

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

service iptables save
systemctl enable iptables
EOF

  tags = {
    Name = "nat-instance"
  }
}


