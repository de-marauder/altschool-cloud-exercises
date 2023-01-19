output "lb_dns" {
  value = aws_lb.altschool-lb.dns_name
}
output "bastion_pub_ip" {
  value = aws_instance.altschool-bastion.public_ip
}
output "bastion_priv_ip" {
  value = aws_instance.altschool-bastion.private_ip
}
output "replica_priv_ip" {
  value = aws_instance.altschool-replica[0].private_ip
}
output "replica_priv_ip" {
  value = aws_instance.altschool-replica[1].private_ip
}
