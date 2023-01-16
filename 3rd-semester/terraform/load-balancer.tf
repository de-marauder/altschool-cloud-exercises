resource "aws_lb" "altschool-lb" {
  name               = "altschool-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.altschool-allow-web.id]

  subnets = [
    aws_subnet.altschool-pub-subnet-1.id,
    aws_subnet.altschool-pub-subnet-2.id,
    aws_subnet.altschool-priv-subnet-1.id,
    aws_subnet.altschool-priv-subnet-2.id,
  ]

}

resource "aws_lb_target_group" "altschool-targets" {
  name     = "altschool-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.altschool-vpc.id
}

resource "aws_lb_target_group_attachment" "altschool-targets-attach" {
  target_group_arn = aws_lb_target_group.altschool-targets.arn
  count            = 2
  target_id        = aws_instance.altschool-replica[count.index].id
  port             = 80
}

resource "aws_lb_listener" "altschool-listener" {
  load_balancer_arn = aws_lb.altschool-lb.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.altschool-targets.arn
  }

  # default_action {
  #   type = "redirect"

  #   redirect {
  #     port        = "443"
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }
}
