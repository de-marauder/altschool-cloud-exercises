resource "aws_instance" "altschool-replica" {
  ami = var.ubuntu_ami
  # count         = var.instance_count
  for_each      = aws_subnet.altschool-pub-subnet
  subnet_id     = each.value.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.altschool-keypair.key_name

  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo apt update -y
  #             sudo apt install nginx -y
  #             sudo bash -c 'echo "<h1>Welcome to server $(hostname)</h1>" > /var/www/html/index.nginx-debian.html'
  #             EOF

  security_groups = [
    aws_security_group.altschool-replicas-sg.id
  ]

  tags = {
    Name = "${var.instance_tag_name}-${each.key}"
  }

  lifecycle {
    ignore_changes = [
      security_groups
    ]
  }
}
