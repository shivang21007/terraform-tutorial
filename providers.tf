terraform {
  backend "s3" {
    bucket       = "shivang21007-tf-state-backend" # The bucket you just created
    key          = "practice/terraform.tfstate" # The path inside the bucket
    region       = "ap-south-1" # Your AWS region where bucket lives
    
    # 🌟 THIS IS THE MAGIC LINE FOR NATIVE LOCKING! 🌟
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.49.0"
    }
  }
}
