output "lb_dns" {
  value = aws_lb.altschool-lb.dns_name
}
output "route_53" {
  value = aws_route53_zone.main.name
}
output "route_53_ns" {
  value = aws_route53_zone.main.name_servers
}
output "site_URL" {
  value = aws_route53_record.a.name
}
output "replica_1_ip" {
  value = aws_instance.altschool-replica["1"].public_ip
}
output "replica_2_ip" {
  value = aws_instance.altschool-replica["2"].public_ip
}
