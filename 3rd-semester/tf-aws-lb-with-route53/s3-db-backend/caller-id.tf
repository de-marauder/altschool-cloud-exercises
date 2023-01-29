provider "aws" {
  profile = "terraform"
  region  = var.aws_region
}

data "aws_caller_identity" "current" {}

output "caller-id" {
  value = data.aws_caller_identity.current
}
