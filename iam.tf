/*
Access the IAM console, and create a role.
Attach the AmazonSSMManagedInstanceCore policy to the role during creation.
Name your role MySSMRole.
*/

//Create Assume role policy data variable
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

// Create managed policy data variable
data "aws_iam_policy" "AmazonEC2RoleforSSM" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "MySSMRole" {
  name               = "MySSMRole"
  description        = "Allows EC2 instances to call SSM on your behalf"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_instance_profile" "remote2ec2_instace_profile" {
  name = "MySSMRole"
  path = "/"
  role = aws_iam_role.MySSMRole.name
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attach" {
  role       = aws_iam_role.MySSMRole.name
  policy_arn = data.aws_iam_policy.AmazonEC2RoleforSSM.arn
}
