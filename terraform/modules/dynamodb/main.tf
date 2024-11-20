resource "aws_dynamodb_table" "feedback_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST" # On-demand billing
  hash_key     = var.hash_key
  range_key    = var.range_key

  attribute {
    name = var.hash_key
    type = "S" # String (FeedbackID)
  }

  attribute {
    name = var.range_key
    type = "S" # String (User)
  }

  tags = var.tags
}
