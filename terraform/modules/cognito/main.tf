resource "aws_cognito_user_pool" "cognito_user_pool" {
  name = var.cognito_user_pool_name
}

resource "aws_cognito_user_pool_client" "cognito_user_pool_client" {
  name         = var.cognito_user_pool_client_name
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id

  callback_urls                        = ["https://example.com"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["aws.cognito.signin.user.admin", "email", "openid", "profile"]
  explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user" "test_user" {
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
  username     = "brice.h"
  password     = "Test@123"
}