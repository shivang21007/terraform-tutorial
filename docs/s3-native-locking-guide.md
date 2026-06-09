# Step-by-Step Guide: Native S3 State Management & Locking

This guide will walk you through how to practice and configure **Terraform Native S3 Locking** (introduced in Terraform v1.10). This modern approach eliminates the need for DynamoDB tables!

## Prerequisites
- **Terraform v1.10** or newer. (Run `terraform version` to check).
- AWS CLI configured with your credentials.

---

## Step 1: Create an S3 Bucket
Before Terraform can store state remotely, the S3 bucket must exist. It is best practice to create this bucket using the AWS CLI or the console (since if you use Terraform to create the bucket that stores your Terraform state, you create a "chicken-and-egg" problem!).

Run this in your terminal (make sure to change the bucket name to something globally unique):
```bash
aws s3api create-bucket \
    --bucket my-unique-terraform-state-bucket-name \
    --region ap-south-1 \
    --create-bucket-configuration LocationConstraint=ap-south-1
```
*(Note: If using `us-east-1`, you can omit the LocationConstraint parameter).*

## Step 2: Enable Bucket Versioning (CRITICAL)
Terraform's lockfile and state management heavily rely on S3 versioning. This ensures you can always recover older state files if something goes wrong, and it is a strict requirement for native locking.

```bash
aws s3api put-bucket-versioning \
    --bucket my-unique-terraform-state-bucket-name \
    --versioning-configuration Status=Enabled
```

## Step 3: Configure the Terraform Backend
In your Terraform project (e.g., inside a new `provider.tf` or at the top of your `ec2.tf`), add the `backend "s3"` configuration block inside the `terraform` block.

```hcl
terraform {
  # Add this backend block
  backend "s3" {
    bucket       = "my-unique-terraform-state-bucket-name" # The bucket you just created
    key          = "practice/terraform.tfstate"            # The path inside the bucket
    region       = "ap-south-1"                        # Your AWS region
    
    # 🌟 THIS IS THE MAGIC LINE FOR NATIVE LOCKING! 🌟
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

*Note: Notice there is no `dynamodb_table` parameter here!*

## Step 4: Initialize the Backend
Since you are changing where Terraform stores its state (from local to remote), you must initialize it.

Run:
```bash
terraform init
```

If you already had a local `terraform.tfstate` file, Terraform will detect it and ask:
> *"Do you want to copy existing state to the new backend?"* 

Type **`yes`**.

## Step 5: Test the Lock!
Let's prove that the native S3 locking actually works. You can simulate a lock collision by running two `apply` commands at the exact same time.

1. Open **Terminal A**, navigate to your project, and run:
   ```bash
   terraform apply
   ```
   *(Do not type `yes` yet! Just leave it sitting at the prompt. By reaching the prompt, Terraform has already locked the state.)*

2. Open **Terminal B**, navigate to the same project, and run:
   ```bash
   terraform apply
   ```

**What happens?**
Terminal B will immediately throw an error that looks something like this:
> `Error: Error acquiring the state lock`
> `Error message: Lock already acquired by another process.`

If you go log into your AWS S3 Console, you will see a tiny file named `.tflock` sitting next to your `terraform.tfstate` file. 

Once you type `yes` (or `no` to cancel) in Terminal A, Terraform will complete its run and automatically delete the `.tflock` file. Terminal B will then be allowed to run!

## Summary
You have successfully implemented modern, DynamoDB-free remote state locking! 

**Best Practices Checklist:**
- [ ] Keep your S3 bucket completely private (Block Public Access).
- [ ] Never delete the `.tfstate` files manually from the console.
- [ ] Keep versioning enabled indefinitely.
