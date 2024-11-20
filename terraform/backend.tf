terraform {
  backend "s3" {
    bucket = "feedback-management-backend"
    key    = "terraform/terraform.tfstate"
    region = "eu-west-3"
  }
}
