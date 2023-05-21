output "key_id" {
  value = aws_kms_key.web_kms_key.key_id
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "asg_name" {
  value = aws_autoscaling_group.autoscaling_group.id
}

output "asg_desired_count" {
  value = aws_autoscaling_group.autoscaling_group.desired_capacity
}

output "asg_min_size" {
  value = aws_autoscaling_group.autoscaling_group.min_size
}
