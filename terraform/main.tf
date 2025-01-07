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

module "lambda_create" {
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

module "lambda_delete" {
  source                    = "./modules/lambda"
  lambda_function_name      = "delete-feedback"
  lambda_runtime            = "python3.8"
  lambda_timeout            = 10
  lambda_memory_size        = 128
  dynamodb_table_name       = module.dynamodb.table_name
  pathToLambdaCode          = "../lambda/delete_feedback/handler.py.zip"
  lambda_layer_name         = "feedbackLayer"
  lambda_layer_s3_bucket    = "feedback-management-backend"
  lambda_layer_s3_key       = "lambda/lambda_layer.zip"
  lambda_role_arn           = module.iam.lambda_role_arn
  api_gateway_execution_arn = module.api_gateway.execution_arn
}

module "lambda_update" {
  source                    = "./modules/lambda"
  lambda_function_name      = "update-feedback"
  lambda_runtime            = "python3.8"
  lambda_timeout            = 10
  lambda_memory_size        = 128
  dynamodb_table_name       = module.dynamodb.table_name
  pathToLambdaCode          = "../lambda/update_feedback/handler.py.zip"
  lambda_layer_name         = "feedbackLayer"
  lambda_layer_s3_bucket    = "feedback-management-backend"
  lambda_layer_s3_key       = "lambda/lambda_layer.zip"
  lambda_role_arn           = module.iam.lambda_role_arn
  api_gateway_execution_arn = module.api_gateway.execution_arn
}

module "lambda_list" {
  source                    = "./modules/lambda"
  lambda_function_name      = "get-feedbacks"
  lambda_runtime            = "python3.8"
  lambda_timeout            = 10
  lambda_memory_size        = 128
  dynamodb_table_name       = module.dynamodb.table_name
  pathToLambdaCode          = "../lambda/get_feedback/handler.py.zip"
  lambda_layer_name         = "feedbackLayer"
  lambda_layer_s3_bucket    = "feedback-management-backend"
  lambda_layer_s3_key       = "lambda/lambda_layer.zip"
  lambda_role_arn           = module.iam.lambda_role_arn
  api_gateway_execution_arn = module.api_gateway.execution_arn
}

module "lambda_get_feedback_by_id" {
  source                    = "./modules/lambda"
  lambda_function_name      = "get-feedback-by-id"
  lambda_runtime            = "python3.8"
  lambda_timeout            = 10
  lambda_memory_size        = 128
  dynamodb_table_name       = module.dynamodb.table_name
  pathToLambdaCode          = "../lambda/get_feedback_by_id/handler.py.zip"
  lambda_layer_name         = "feedbackLayer"
  lambda_layer_s3_bucket    = "feedback-management-backend"
  lambda_layer_s3_key       = "lambda/lambda_layer.zip"
  lambda_role_arn           = module.iam.lambda_role_arn
  api_gateway_execution_arn = module.api_gateway.execution_arn
}

module "cognito" {
  source                        = "./modules/cognito"
  cognito_user_pool_name        = "feedback_user_pool"
  cognito_user_pool_client_name = "feedback_user_pool_client_name"
}

module "api_gateway" {
  source                        = "./modules/api-gateway"
  api_name                      = "FeedbackAPI"
  api_description               = "API Gateway for Feedback Management"
  get_feedback_by_id_invoke_arn = module.lambda_get_feedback_by_id.lambda_invoke_arn
  create_feedback_invoke_arn    = module.lambda_create.lambda_invoke_arn
  delete_feedback_invoke_arn    = module.lambda_delete.lambda_invoke_arn
  get_all_feedback_invoke_arn   = module.lambda_list.lambda_invoke_arn
  update_feedback_invoke_arn    = module.lambda_update.lambda_invoke_arn
  cognito_user_pool_arn         = module.cognito.user_pool_arn
}
