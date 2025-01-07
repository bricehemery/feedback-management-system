# Define the REST API
resource "aws_api_gateway_rest_api" "rest_api" {
  name        = var.api_name
  description = var.api_description
}

# Define the root resource for feedbacks
resource "aws_api_gateway_resource" "feedbacks" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "feedbacks"
}

# Define the root resource for feedback by id
resource "aws_api_gateway_resource" "feedback_by_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.feedbacks.id
  path_part   = "{id}"
}

# Define the GET method to get all feedbacks
resource "aws_api_gateway_method" "get_feedbacks" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.feedbacks.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}
# Integrate the GET method with Lambda
resource "aws_api_gateway_integration" "get_feedbacks_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.feedbacks.id
  http_method             = aws_api_gateway_method.get_feedbacks.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_all_feedback_invoke_arn
}

# Define the Method Response
resource "aws_api_gateway_method_response" "get_feedbacks_method_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.feedbacks.id
  http_method = aws_api_gateway_method.get_feedbacks.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  # Cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method" "feedbacks_options" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.feedbacks.id
  http_method   = "OPTIONS"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "feedbacks_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.feedbacks.id
  http_method = aws_api_gateway_method.feedbacks_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "feedbacks_options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.feedbacks.id
  http_method = aws_api_gateway_method.feedbacks_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" : true
    "method.response.header.Access-Control-Allow-Methods" : true
    "method.response.header.Access-Control-Allow-Headers" : true
  }
}

resource "aws_api_gateway_integration_response" "feedbacks_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.feedbacks.id
  http_method = aws_api_gateway_method.feedbacks_options.http_method
  status_code = aws_api_gateway_method_response.feedbacks_options_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" : "'GET,POST,PUT,DELETE,OPTIONS'"
  }

  depends_on = [aws_api_gateway_integration.feedbacks_options_integration, aws_api_gateway_method.feedbacks_options]
}


# Define the POST method to create a feedback
resource "aws_api_gateway_method" "create_feedback" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.feedbacks.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

# Integrate the POST method with Lambda
resource "aws_api_gateway_integration" "create_feedback_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.feedbacks.id
  http_method             = aws_api_gateway_method.create_feedback.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.create_feedback_invoke_arn
}

# Define the Method Response
resource "aws_api_gateway_method_response" "create_feedback_method_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.feedbacks.id
  http_method = aws_api_gateway_method.create_feedback.http_method
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

# Define the GET method to get a feedback by id
resource "aws_api_gateway_method" "get_feedback_by_id" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.feedback_by_id.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

# Integrate the GET method with Lambda
resource "aws_api_gateway_integration" "get_feedback_by_id_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.feedback_by_id.id
  http_method             = aws_api_gateway_method.get_feedback_by_id.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_feedback_by_id_invoke_arn
}

# Define the Method Response
resource "aws_api_gateway_method_response" "get_feedback_by_id_method_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.feedback_by_id.id
  http_method = aws_api_gateway_method.get_feedback_by_id.http_method
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

# Define the DELETE method to delete a feedback
resource "aws_api_gateway_method" "delete_feedback" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.feedback_by_id.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

# Integrate the DELETE method with Lambda
resource "aws_api_gateway_integration" "delete_feedback_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.feedback_by_id.id
  http_method             = aws_api_gateway_method.delete_feedback.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.delete_feedback_invoke_arn
}

# Define the Method Response
resource "aws_api_gateway_method_response" "delete_feedback_method_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.feedback_by_id.id
  http_method = aws_api_gateway_method.delete_feedback.http_method
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

# Define the PUT method to update a feedback
resource "aws_api_gateway_method" "update_feedback" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.feedback_by_id.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

# Integrate the PUT method with Lambda
resource "aws_api_gateway_integration" "update_feedback_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.feedback_by_id.id
  http_method             = aws_api_gateway_method.update_feedback.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.update_feedback_invoke_arn
}

# Define the Method Response
resource "aws_api_gateway_method_response" "update_feedback_method_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.feedback_by_id.id
  http_method = aws_api_gateway_method.update_feedback.http_method
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

# Cognito Authorizer
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "cognito-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [var.cognito_user_pool_arn]
}

# Deployment of the API Gateway
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = var.stage_name

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.feedbacks.id,
      aws_api_gateway_resource.feedback_by_id.id,
      aws_api_gateway_method.create_feedback.http_method,
      aws_api_gateway_method.get_feedbacks.http_method,
      aws_api_gateway_method.get_feedback_by_id.http_method,
      aws_api_gateway_method.update_feedback.http_method,
      aws_api_gateway_method.delete_feedback.http_method,
      aws_api_gateway_method.feedbacks_options.http_method,
      aws_api_gateway_integration.create_feedback_integration.id,
      aws_api_gateway_integration.get_feedbacks_integration.id,
      aws_api_gateway_integration.get_feedback_by_id_integration.id,
      aws_api_gateway_integration.update_feedback_integration.id,
      aws_api_gateway_integration.delete_feedback_integration.id,
      aws_api_gateway_integration.feedbacks_options_integration.id
    ]))
  }

  depends_on = [
    aws_api_gateway_integration.create_feedback_integration,
    aws_api_gateway_integration.get_feedbacks_integration,
    aws_api_gateway_integration.get_feedback_by_id_integration,
    aws_api_gateway_integration.update_feedback_integration,
    aws_api_gateway_integration.delete_feedback_integration,
    aws_api_gateway_integration.feedbacks_options_integration
  ]
}
