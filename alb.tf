#Application Load Balancer Security Group
resource "aws_security_group" "mirzasa-alb-security-group" {
  name = "mirzasa-alb-${var.env}"
  description = "mirzasa Application Load Balancer ${var.env} Environment"
  vpc_id = "${aws_vpc.mirzasa-vpc.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
#   ingress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  tags = {
      Name = "mirzasa-alb-${var.env}"
  }
}
#Application Load Balancer
resource "aws_lb" "mirzasa-alb" {
  name = "mirzasa-${var.env}"
  internal = false
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  security_groups = [
      "${aws_security_group.mirzasa-alb-security-group.id}"
  ]
  subnets = [
      "${aws_subnet.public-subnet-1.id}",
      "${aws_subnet.private-subnet-2.id}"
  ]
}
#Target Group
resource "aws_lb_target_group" "mirzasa-target-group" {
  name = "mirzasa-${var.env}"
  protocol = "HTTP"
  port = 80
  target_type = "ip"
  vpc_id = "${aws_vpc.mirzasa-vpc.id}"
  deregistration_delay = 30
  health_check {
      protocol = "HTTP"
      path = "/"
  }
  depends_on = ["aws_lb.mirzasa-alb"]
}
#LB Listeners
resource "aws_lb_listener" "mirzasa-http" {
  load_balancer_arn = "${aws_lb.mirzasa-alb.arn}"
  port = 80
  protocol = "HTTP"
  default_action {
      type = "forward"
      target_group_arn = "${aws_lb_target_group.mirzasa-target-group.arn}"
  }
}
# # resource "aws_lb_listener" "mirzasa-https" {
# #   load_balancer_arn = "${aws_lb.mirzasa-alb.arn}"
# #   port = 443
# #   protocol = "HTTPS"
# #   ssl_policy = "ELBSecurityPolicy-2016-08"
# #   certificate_arn = "${aws_acm_certificate.mirzasa-com.arn}"
# #   default_action {
# #     type = "forward"
# #     target_group_arn = "${aws_lb_target_group.mirzasa-target-group.arn}"
# #   }
# # }
# #Route 53 A Record Alias
# # resource "aws_route53_record" "mirzasa-alb" {
# #   zone_id = "${aws_route53_zone.mirzasa.zone_id}"
# #   name = "www.mirzasa.com"
# #   type = "A"
# #   alias {
# #     name = "${aws_lb.mirzasa-alb.dns_name}"
# #     zone_id = "${aws_lb.mirzasa-alb.zone_id}"
# #     evaluate_target_health = true
# #   }
# # }