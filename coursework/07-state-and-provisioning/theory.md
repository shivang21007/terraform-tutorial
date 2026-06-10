# Module 7: State Manipulation & Provisioners

As a DevOps Engineer, you won't just write new code—you will have to fix existing infrastructure, import manually created resources, and run local scripts.

## 1. State Manipulation
Sometimes the Terraform state file gets out of sync with reality, or you need to refactor your code without destroying the actual infrastructure.

- **`terraform import ADDR ID`**: If someone manually created a resource in AWS, Terraform doesn't know about it. You can pull it into your state file!
  - **`ADDR`**: The "Address" in your Terraform code (e.g., `aws_s3_bucket.my_bucket`).
  - **`ID`**: The unique identifier in AWS (e.g., the bucket name `shivang-manual-bucket`, or an EC2 Instance ID `i-0abcd1234`).
  
  > **Important Note on Importing Complex Resources:**
  > When you import an EC2 instance, Terraform downloads its current state from AWS into your `terraform.tfstate` file. However, **it does not write the `.tf` code for you**. 
  > You must manually write out the `ami`, `instance_type`, and other required arguments in your `.tf` file to match the real-world server. If your code is empty or doesn't perfectly match the imported state, your next `terraform plan` will try to destroy or modify the server to match your empty code!
- **`terraform state mv`**: If you rename a resource in your `.tf` file (e.g. from `aws_instance.web` to `aws_instance.frontend`), Terraform will want to destroy the old one and create a new one. To prevent this, use `terraform state mv aws_instance.web aws_instance.frontend`.
- **`terraform state rm`**: If you want Terraform to "forget" about a resource (so you can delete it from your code without Terraform destroying the actual AWS resource), use `terraform state rm`.

## 2. Provisioners
You've already used `user_data` to run scripts when an EC2 instance boots. Terraform also has **Provisioners** that run scripts during resource creation or destruction.

*Note: HashiCorp strongly recommends using `user_data` or configuration management tools (like Ansible) instead of provisioners, but you will see them in legacy code.*

- **`local-exec`**: Runs a script on the machine running Terraform (your laptop or CI/CD pipeline).
- **`remote-exec`**: SSHs into the newly created server and runs a script.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }
}
```

Go to `assignment/README.md` to practice!
