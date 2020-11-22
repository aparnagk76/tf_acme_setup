# create a vpc
resource aws_vpc aparnavpc {
  cidr_block = "10.0.0.0/16"

  tags = {
    name = "dev"
  }
}
# create an internet gateway

resource aws_internet_gateway gw {
  vpc_id = aws_vpc.aparnavpc.id
}

# create a nat 

resource aws_eip nat {
  vpc = true
}

# create a nat gateway

resource aws_nat_gateway nat-gw {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main.id

}

# create route table
resource aws_route_table r {
  vpc_id = aws_vpc.aparnavpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# create private route table

resource aws_route_table private-rta {
  vpc_id = aws_vpc.aparnavpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id

  }
}

# create a private route table association

resource aws_route_table_association private-rta {
  subnet_id      = aws_subnet.internal.id
  route_table_id = aws_route_table.private-rta.id
}
# create a route table association
resource aws_route_table_association rta {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.r.id
}


# Create a public subnet

resource aws_subnet main {
  vpc_id     = aws_vpc.aparnavpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    name = "dev"
  }
}

#create a private subnet

resource aws_subnet internal {
  vpc_id     = aws_vpc.aparnavpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    name = "dev"
  }
}

data aws_ami amazon-linux2 {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource aws_security_group allow_ssh {
  name        = "nginx-demo"
  description = "allow ports for nginx demo"
  vpc_id      = aws_vpc.aparnavpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow port 22"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow port 80"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow traffic outside to internet"
    from_port   = 0
    protocol    = -1
    to_port     = 0
  }
}

resource aws_instance nginx-lb {
  ami                         = data.aws_ami.amazon-linux2.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.main.id
  count                       = 1
  associate_public_ip_address = true
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }
  provisioner remote-exec {
    inline = [
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum install nginx -y",
      "sudo systemctl -l enable nginx",
      "sudo systemctl -l start nginx"
    ]
  }
}


resource aws_instance private-nginx {
  ami                         = data.aws_ami.amazon-linux2.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.internal.id
  count                       = 2
  associate_public_ip_address = false
  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)

    bastion_host        = aws_instance.nginx-lb[0].public_ip
    bastion_user        = "ec2-user"
    bastion_host_key    = var.key_name
    bastion_private_key = file(var.private_key_path)
  }
  provisioner remote-exec {
    inline = [
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum install nginx -y",
      "sudo systemctl -l enable nginx",
      "sudo systemctl -l start nginx"
    ]
  }
}

