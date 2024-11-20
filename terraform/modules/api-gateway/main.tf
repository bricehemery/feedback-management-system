# Define the REST API
resource "aws_api_gateway_rest_api" "rest_api" {
  name        = var.api_name
  description = var.api_description
}

# Define the root resource for feedback
resource "aws_api_gateway_resource" "feedback_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = var.feedback_path
}

# Define the POST method for the feedback resource
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.feedback_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integrate the POST method with Lambda
resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.feedback_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# Define the Method Response
resource "aws_api_gateway_method_response" "post_method_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.feedback_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  # Cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Define the Integration Response
resource "aws_api_gateway_integration_response" "post_integration_response" {
  rest_api_id       = aws_api_gateway_rest_api.rest_api.id
  resource_id       = aws_api_gateway_resource.feedback_resource.id
  http_method       = aws_api_gateway_method.post_method.http_method
  status_code       = aws_api_gateway_method_response.post_method_response.status_code
  selection_pattern = ""

  # Cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_method.post_method, aws_api_gateway_integration.post_integration]
}

# Deployment of the API Gateway
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = var.stage_name

  depends_on = [
    aws_api_gateway_integration.post_integration,
    aws_api_gateway_method_response.post_method_response,
    aws_api_gateway_integration_response.post_integration_response
  ]
}
