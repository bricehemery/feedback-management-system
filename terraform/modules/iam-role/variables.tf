variable "lambda_role_name" {
  type        = string
  description = "Name of the IAM role for the Lambda function"
}

variable "dynamodb_table_arn" {
  type        = string
  description = "ARN of the DynamoDB table the Lambda will interact with"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to IAM resources"
  default     = {}
}
