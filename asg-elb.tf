resource "aws_elb" "web_elb" {
  name = "web-elb"

  security_groups = [
    aws_security_group.allow_ssh.id
  ]

  subnets = [
    data.aws_subnets.subnets.ids[0],
    data.aws_subnets.subnets.ids[1],
    data.aws_subnets.subnets.ids[2]
  ]

  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }
}
