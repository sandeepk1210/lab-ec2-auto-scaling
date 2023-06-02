resource "aws_lambda_function" "LogAutoScalingEvent" {
  function_name    = "LogAutoScalingEvent"
  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  handler          = "index.handler"
  role             = aws_iam_role.LogAutoScalingEvent-role.arn
  runtime          = "nodejs14.x"
  #   vpc_config {
  #     subnet_ids         = [aws_subnet.example.id]
  #     security_group_ids = [aws_security_group.example.id]
  #   }
}
