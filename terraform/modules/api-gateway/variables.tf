variable "api_name" {
  type        = string
  description = "Name of the API Gateway REST API"
}

variable "api_description" {
  type        = string
  description = "Description of the API Gateway REST API"
}

variable "feedback_path" {
  type        = string
  description = "Path part for the feedback resource"
  default     = "feedback"
}

variable "lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Lambda function to integrate with API Gateway"
}

variable "stage_name" {
  type        = string
  description = "Name of the deployment stage"
  default     = "dev"
}
