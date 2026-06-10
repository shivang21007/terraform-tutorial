# Assignment 9: Workspaces & Security

In this module, we will learn how to deploy the same infrastructure across multiple environments, and how to scan our code for security flaws.

## Part 1: Workspaces
1. Create a `main.tf` in this directory and configure the AWS provider.
2. Define a simple `aws_s3_bucket` resource.
3. For the `bucket` argument, you must dynamically include the workspace name using string interpolation! 
   - Hint: `bucket = "shivang-batch10-app-${terraform.workspace}"`
4. In your terminal, run `terraform init`.
5. Run `terraform workspace new dev` and then `terraform apply`.
6. Run `terraform workspace new prod` and then `terraform apply`.
7. Go to your AWS console. You should see TWO buckets! One ending in `-dev` and one ending in `-prod`.

## Part 2: Security Auditing
1. In your `main.tf`, write a purposefully *bad* `aws_security_group` that allows port `22` (SSH) ingress from `0.0.0.0/0`.
2. Install `tfsec` on your Mac (you can use brew: `brew install tfsec`).
3. Run `tfsec .` in your terminal.
4. Read the output! It should scream at you with a critical failure for opening SSH to the world.

Let me know when you've triggered the `tfsec` warning and successfully deployed both your `dev` and `prod` buckets!
