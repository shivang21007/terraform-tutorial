terraform {
  backend "s3" {
    bucket         = "shivangguptain-tf-capstone-1"
    key            = "capstone-1/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "shivangguptain-tf-state-table"
  }
}

provider "aws" {
  region = "us-east-1"
}