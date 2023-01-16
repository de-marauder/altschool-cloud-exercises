resource "aws_instance" "altschool-bastion" {
  ami           = var.ubuntu_ami
  subnet_id     = aws_subnet.altschool-pub-subnet-1.id
  instance_type = "t2-micro"
  key_name      = aws_key_pair.altschool-keypair.key_name
  availability_zone = var.az1

  security_groups = [
    aws_security_group.altschool-allow-ssh-pub.id
  ]

  tags = {
    Name = "altschool-bastion"
  }
}

resource "aws_instance" "altschool-replica" {
  ami           = var.ubuntu_ami
  count         = 2
  subnet_id     = aws_subnet.altschool-priv-subnet-1.id
  instance_type = "t2-micro"
  key_name      = aws_key_pair.altschool-keypair.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo bash -c 'echo <h1>Welcome to server $(hostname)</h1> > /var/www/html/index.nginx-debian.html'
              EOF

  security_groups = [
    aws_security_group.altschool-priv-sg.id
  ]

  tags = {
    Name = "altschool-replica"
  }
}
