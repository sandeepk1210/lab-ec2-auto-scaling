variable "AWS_REGION" {
  default = "us-east-1"
}

variable "key_pair_name" {
  default = "automateinfra"
}

variable "asg_name" {
  default = "web-dev-asg"
}
variable "ec2_autoscale_min_size" {
  default = 2
}

variable "ec2_autoscale_max_size" {
  default = 10
}

variable "ec2_autoscale_desired_capacity" {
  default = 1
}

variable "key_spec" {
  default = "SYMMETRIC_DEFAULT"
}

variable "enabled" {
  default = true
}

variable "rotation_enabled" {
  default = false
}

variable "kms_alias" {
  default = "web_kms_key"
}
