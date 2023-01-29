terraform {

  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }

  # Comment in to use a remote backend
  # Make sure to put in the approriate parameters
  # backend "s3" {
  #   bucket         = "remote-backend-s3"
  #   key            = "terraform.tfstate"
  #   dynamodb_table = "remote-backend-lock"

  #   region = "us-east-1"
  # }
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform"
}
