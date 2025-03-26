terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
  }
  # this is the backend configuration for the terraform state file to be stored in s3 bucket and lock table in dynamodb table so that it can be locked and unlocked by multiple users at the same time to avoid conflicts in the state file while running terraform apply command by multiple users at the same time on the same state file stored in s3 bucket.
  backend "s3" {
    bucket         = "my-tf-bucket-for-dynamodb-01"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "my-tf-dynamodb-table-01"
  }
}



provider "aws" {
  # Configuration options
  region = "ap-south-1"
}