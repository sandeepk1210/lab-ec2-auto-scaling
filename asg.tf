data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

# Creating the autoscaling launch template that contains AWS EC2 instance details
resource "aws_launch_template" "autoscale_template" {
  # Defining the name of the Autoscaling launch configuration
  name_prefix = "web-"
  description = "Launch Teamplate created via terraform"
  # Defining the image ID of AWS EC2 instance
  image_id = data.aws_ami.amazon-linux-2.id
  # Defining the instance type of the AWS EC2 instance
  instance_type = "t3a.small"
  # Defining the Key that will be used to access the AWS EC2 instance
  key_name = "automateinfra"

  #vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.allow_ssh.id]
  }

  user_data = filebase64("user_data.sh")
  iam_instance_profile {
    name = aws_iam_role.MySSMRole.name
  }

  #root disk
  # block_device_mappings {
  #   device_name = "/dev/sdf"

  #   ebs {
  #     volume_size           = 20
  #     volume_type           = "gp2"
  #     encrypted             = true
  #     delete_on_termination = true
  #     kms_key_id            = aws_kms_key.web_kms_key.arn
  #   }
  # }

  #data disk
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 50
      volume_type           = "gp2"
      encrypted             = true
      delete_on_termination = true
    }
  }

  monitoring {
    enabled = true
  }

  depends_on = [
    aws_key_pair.automateinfra_public_key
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  update_default_version = true
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name = var.asg_name
  availability_zones = [
    data.aws_availability_zones.availability_zones.names[0],
    data.aws_availability_zones.availability_zones.names[1],
    data.aws_availability_zones.availability_zones.names[2]
  ]
  #availability_zones = [for s in data.aws_availability_zones.availability_zones : s.names]
  #availability_zones = [data.aws_availability_zones.availability_zones.names[*]]
  desired_capacity          = var.ec2_autoscale_min_size
  max_size                  = var.ec2_autoscale_max_size
  min_size                  = var.ec2_autoscale_desired_capacity
  health_check_grace_period = 300
  health_check_type         = "EC2"

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  #load_balancers = [aws_lb.web_lb.id]

  launch_template {
    id      = aws_launch_template.autoscale_template.id
    version = "$Latest"
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "web-dev-asg"
    propagate_at_launch = false
  }

  tag {
    key                 = "cost_center"
    value               = "V_FAKE"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_lifecycle_hook" "autoscaling_lifecycle_hook" {
  name                   = "autoscaling_lifecycle_hook"
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 120
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
}
