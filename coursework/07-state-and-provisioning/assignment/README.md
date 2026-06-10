# Assignment 7: Import and Local-Exec

## Part 1: The Local-Exec Provisioner
1. Create a `main.tf` and set up your AWS provider.
2. Create an `aws_instance` (you can hardcode an Ubuntu or Amazon Linux AMI ID and instance type for speed).
3. Add a `provisioner "local-exec"` block inside the instance.
4. Have it run a command that outputs the instance's public IP to a local file named `server_ip.txt`.
   *(Hint: `command = "echo ${self.public_ip} > server_ip.txt"`)*
5. Apply the code and verify the file is created on your laptop!

## Part 2: Terraform Import (The DevOps Lifesaver)
1. Go to the AWS Console in your browser.
2. Manually create an S3 bucket. Give it a globally unique name (e.g., `shivang-manual-bucket-12345`). Do NOT create it using Terraform.
3. Now, pretend you are tasked with bringing that manual bucket under Terraform's control.
4. In your `main.tf`, write an empty resource block:
   ```hcl
   resource "aws_s3_bucket" "imported_bucket" {
     bucket = "shivang-manual-bucket-12345" # Must match exactly!
   }
   ```
5. In your terminal, run: `terraform import aws_s3_bucket.imported_bucket shivang-manual-bucket-12345`
6. Run `terraform plan`. It should say `No changes. Your infrastructure matches the configuration.` You have successfully imported it!
7. Finally, run `tf destroy` to clean everything up (including the manually created bucket, which Terraform now owns!).

Let me know when you finish!
