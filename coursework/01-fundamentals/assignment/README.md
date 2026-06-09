# Assignment 1: Your First Infrastructure

## 🎯 Objective
Write a completely from-scratch Terraform configuration that provisions a single AWS EC2 instance. 

To prove you understand the absolute basics, **you are not allowed to use any variables (`var.xxx`) or outputs yet.** Everything must be hardcoded.

## 📝 Requirements

1. Create a `main.tf` file inside this `assignment/` directory.
2. Add a `provider` block for AWS, setting the region to `ap-south-1`.
3. Add a `resource` block to create an `aws_instance`.
   - Name the resource `my_first_server`.
   - Use the AMI ID: `ami-0ba6f2c4de657798c` (Ubuntu).
   - Use the instance type: `t3.micro`.
   - Add a `tags` block and give it a Name tag: `Name = "Terraform-Student-Server"`.
4. Run the Terraform lifecycle commands to deploy it.

## 🚦 Instructions
Open your terminal and `cd` into this directory:
```bash
cd coursework/01-fundamentals/assignment/
```

1. Write your `main.tf`.
2. Run `terraform init`.
3. Run `terraform plan`.
4. Run `terraform apply`.

## 🧑‍🏫 Evaluation
When you are done, run `terraform destroy` to clean up your AWS account! 

Then, **message me here in the chat** telling me you are done. I will review your `main.tf` file, give you feedback, and unlock Module 2!
