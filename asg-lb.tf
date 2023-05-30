resource "aws_lb" "web_lb" {
  name = "web-lb"

  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.allow_ssh.id
  ]

  subnets = [
    data.aws_subnets.subnets.ids[0],
    data.aws_subnets.subnets.ids[1],
    data.aws_subnets.subnets.ids[2]
  ]

  enable_deletion_protection = true
}
