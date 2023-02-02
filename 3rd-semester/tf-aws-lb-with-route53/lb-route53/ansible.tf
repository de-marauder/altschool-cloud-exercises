resource "local_file" "ansible" {
  content  = <<-EOF
              [web_servers]
              ${aws_instance.altschool-replica["1"].public_ip} ansible_user=ubuntu
              ${aws_instance.altschool-replica["2"].public_ip} ansible_user=ubuntu
              ${aws_instance.altschool-replica["3"].public_ip} ansible_user=ubuntu
              EOF

  filename = "ansible/host-inventory"
  file_permission = "0644"
}
