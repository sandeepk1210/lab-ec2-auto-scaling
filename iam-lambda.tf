/*
Access the IAM console, and create a role.
Create an execution role and a permissions policy to allow Lambda to complete lifecycle hooks
*/

//Create Assume role policy data variable
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "LogAutoScalingEvent-policy" {
  statement {
    effect    = "Allow"
    actions   = ["autoscaling:CompleteLifecycleAction"]
    resources = ["arn:aws:autoscaling:*:${data.aws_caller_identity.current.account_id}:autoScalingGroup:*:autoScalingGroupName/${var.asg_name}"]
  }
}

data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "LogAutoScalingEvent-policy" {
  name        = "LogAutoScalingEvent-policy"
  description = "Access to autoscaling"
  path        = "/"

  policy = data.aws_iam_policy_document.LogAutoScalingEvent-policy.json
}

resource "aws_iam_role" "LogAutoScalingEvent-role" {
  name               = "LogAutoScalingEvent-role"
  description        = "Create an execution role and a permissions policy to allow Lambda to complete lifecycle hooks"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

# resource "aws_iam_instance_profile" "remote2ec2_instace_profile" {
#   name = "MySSMRole"
#   path = "/"
#   role = aws_iam_role.MySSMRole.name
# }

locals {
  policy_set = [
    aws_iam_policy.LogAutoScalingEvent-policy.arn,
    data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
  ]
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  count = length(local.policy_set)

  role       = aws_iam_role.LogAutoScalingEvent-role.name
  policy_arn = local.policy_set[count.index]
}
