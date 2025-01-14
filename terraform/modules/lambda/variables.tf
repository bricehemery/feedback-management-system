variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "lambda_runtime" {
  type        = string
  description = "Runtime environment for the Lambda function"
  default     = "python3.8"
}

variable "image_uri" {
  type        = string
  description = "URI of the Docker image for the Lambda function"
}

variable "lambda_timeout" {
  type        = number
  description = "Timeout for the Lambda function in seconds"
  default     = 10
}

variable "lambda_memory_size" {
  type        = number
  description = "Memory size for the Lambda function"
  default     = 128
}

variable "dynamodb_table_name" {
  type        = string
  description = "Name of the DynamoDB table"
}

# variable "pathToLambdaCode" {
#   type        = string
#   description = "Path to the Lambda code"
# }

variable "lambda_layer_name" {
  type        = string
  description = "Name of the Lambda layer"
}

variable "lambda_layer_s3_bucket" {
  type        = string
  description = "S3 bucket where the Lambda layer is stored"
}

variable "lambda_layer_s3_key" {
  type        = string
  description = "S3 key for the Lambda layer"
}

variable "lambda_role_arn" {
  type        = string
  description = "ARN of the IAM role for the Lambda function"
}

variable "api_gateway_execution_arn" {
  type        = string
  description = "Execution ARN of the API Gateway REST API"
}
