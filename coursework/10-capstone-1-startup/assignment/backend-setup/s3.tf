provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "my_s3" {
  bucket = "shivangguptain-tf-capstone-1"
}

resource "aws_s3_bucket_versioning" "my_s3_versioning" {
  bucket = aws_s3_bucket.my_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "my_dynamodb" {
  name = "shivangguptain-tf-state-table"
  billing_mode = "PAY_PER_REQUEST" 
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  
}