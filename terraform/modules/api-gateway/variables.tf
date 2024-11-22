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

variable "stage_name" {
  type        = string
  description = "Name of the deployment stage"
  default     = "dev"
}

variable "create_feedback_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Lambda function to integrate with API Gateway"
}

variable "get_all_feedback_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Lambda function to retrieve all feedback"
}

variable "get_feedback_by_id_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Lambda function to retrieve feedback by ID"
}

variable "delete_feedback_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Lambda function to delete feedback"
}

variable "update_feedback_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Lambda function to update feedback"
}
