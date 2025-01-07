output "user_pool_arn" {
  value       = aws_cognito_user_pool.cognito_user_pool.arn
  description = "The ARN of the Cognito User Pool"
}