# Lambda Trust Relationship
data "aws_iam_policy_document" "lambda_trust_relationship" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    effect = "Allow"
  }
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_role" {
  name               = "Lambda-Execution-Role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_relationship.json
}

# Dynamodb table Read Policy
data "aws_iam_policy_document" "readpolicy" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:ListTables",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]

    resources = [var.dynamodb_table_arn]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "readpolicy" {
  name   = "DynamoDb-Read-Policy"
  policy = data.aws_iam_policy_document.readpolicy.json
}

// dynamodb table Write Policy
data "aws_iam_policy_document" "writepolicy" {
  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:ListTables",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateTable",
    ]

    resources = [var.dynamodb_table_arn]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "writepolicy" {
  name   = "DynamoDb-Write-Policy"
  policy = data.aws_iam_policy_document.writepolicy.json
}

# Attach DynamoDB Read Policy to the Role
resource "aws_iam_role_policy_attachment" "lambda_read_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.readpolicy.arn
}

# Attach DynamoDB Write Policy to the Role
resource "aws_iam_role_policy_attachment" "lambda_write_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.writepolicy.arn
}

# Add AWS Managed CloudWatch Logs Policy
resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}