output "lambda_function_name" {
  value       = aws_lambda_function.feedback_lambda.function_name
  description = "The name of the Lambda function"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.feedback_lambda.arn
  description = "The ARN of the Lambda function"
}

output "lambda_layer_arn" {
  value       = aws_lambda_layer_version.feedback_layer.arn
  description = "The ARN of the Lambda layer"
}

output "lambda_invoke_arn" {
  value       = aws_lambda_function.feedback_lambda.invoke_arn
  description = "The ARN to invoke the Lambda function"
}