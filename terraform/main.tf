module "dynamodb" {
  source = "./modules/dynamodb"

  table_name = "FeedbackTable"
  hash_key   = "FeedbackID" # Partition key
  range_key  = "User"       # Sort key

  tags = {
    Environment = "dev"
    Project     = "FeedbackManagement"
  }
}

module "iam" {
  source             = "./modules/iam-role"
  lambda_role_name   = "feedback_lambda_role"
  dynamodb_table_arn = module.dynamodb.table_arn
  tags               = { Environment = "dev", Project = "FeedbackAPI" }
}

module "lambda" {
  source                    = "./modules/lambda"
  lambda_function_name      = "create-feedback"
  lambda_runtime            = "python3.8"
  lambda_timeout            = 10
  lambda_memory_size        = 128
  dynamodb_table_name       = module.dynamodb.table_name
  pathToLambdaCode          = "../lambda/create_feedback/handler.py.zip"
  lambda_layer_name         = "feedbackLayer"
  lambda_layer_s3_bucket    = "feedback-management-backend"
  lambda_layer_s3_key       = "lambda/lambda_layer.zip"
  lambda_role_arn           = module.iam.lambda_role_arn
  api_gateway_execution_arn = module.api_gateway.execution_arn
}

module "api_gateway" {
  source            = "./modules/api-gateway"
  api_name          = "FeedbackAPI"
  api_description   = "An API Gateway for handling user feedback creation"
  feedback_path     = "feedback"
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  stage_name        = "dev"
}
