resource "aws_route53_zone" "main" {
  name = var.route53_zone_dns
}

resource "aws_route53_record" "a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.subdomain_host}.${var.route53_zone_dns}"
  type = "A"

  alias {
    name                   = aws_lb.altschool-lb.dns_name
    zone_id                = aws_lb.altschool-lb.zone_id
    evaluate_target_health = true
  }
}

