output "lambda_role_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "The ARN of the IAM role used by Lambda"
}

output "lambda_role_name" {
  value       = aws_iam_role.lambda_role.name
  description = "The name of the IAM role used by Lambda"
}
