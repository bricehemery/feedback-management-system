resource "aws_lambda_function" "feedback_lambda" {
  function_name = var.lambda_function_name
  role          = var.lambda_role_arn
  # handler       = "handler.lambda_handler"
  # runtime       = var.lambda_runtime
  package_type = "Image"
  timeout      = var.lambda_timeout
  memory_size  = var.lambda_memory_size

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name
    }
  }

  layers = [aws_lambda_layer_version.feedback_layer.arn]

  image_uri = var.image_uri

  # filename         = var.pathToLambdaCode                   # Path to the Lambda code in the repo
  # source_code_hash = filebase64sha256(var.pathToLambdaCode) # Hash for the Lambda code file
}

resource "aws_lambda_layer_version" "feedback_layer" {
  layer_name = var.lambda_layer_name
  s3_bucket  = var.lambda_layer_s3_bucket
  s3_key     = var.lambda_layer_s3_key
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.feedback_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*/*"
}
