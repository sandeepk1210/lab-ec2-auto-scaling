Terraform code to

- create EC2 instance
- EC2 instance are behind AutoScaling group
  - Autoscaling group has life cycle hook
- Lambda creation (node application doesn't work)
- Eventbridge rule creation which would trigger Lambda based on AutoScaling life cycle hook
- Load balancer creation (not complete)
- IAM roles creation
  - IAM role for ec2
  - IAM role for lambda



New changes
