output "rest_api_id" {
  value       = aws_api_gateway_rest_api.rest_api.id
  description = "The ID of the API Gateway REST API"
}

output "rest_api_endpoint" {
  value       = aws_api_gateway_deployment.api_deployment.invoke_url
  description = "The endpoint URL of the API Gateway"
}

output "stage_name" {
  value       = var.stage_name
  description = "The name of the deployment stage"
}

output "execution_arn" {
  value       = aws_api_gateway_rest_api.rest_api.execution_arn
  description = "The execution ARN of the API Gateway"
}