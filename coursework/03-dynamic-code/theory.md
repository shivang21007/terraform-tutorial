# Module 3: Dynamic Code (Variables, Outputs, and Data Sources)

Welcome to Module 3! So far, our configurations have been completely hardcoded. While that's fine for learning, real-world infrastructure needs to be reusable and dynamic. In this module, you'll learn how to parameterize your Terraform code.

## 1. Input Variables (`variables.tf`)
Variables allow you to pass values into your configuration, making your code reusable across different environments (like `dev`, `staging`, `prod`).

```hcl
variable "instance_type" {
  description = "The type of EC2 instance to run"
  type        = string
  default     = "t3.micro"
}
```
You can reference variables in your configuration using `var.instance_type`.
Values can be provided via a `terraform.tfvars` file, command-line flags (`-var`), or environment variables (`TF_VAR_instance_type`).

## 2. Output Values (`outputs.tf`)
Outputs are like return values for your Terraform modules. After `terraform apply` finishes, it prints out the values you've defined here. It's incredibly useful for getting dynamic data, like the public IP address of an instance that AWS just generated.

```hcl
output "server_public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.my_server.public_ip
}
```

## 3. Data Sources
Data sources allow Terraform to fetch information defined outside of Terraform, or defined by a separate Terraform configuration.
For example, instead of hardcoding an AMI ID (which changes over time and differs by region), you can use a Data Source to ask AWS for the latest Amazon Linux AMI.

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
```
You reference it using `data.aws_ami.amazon_linux.id`.

## 4. Local Values (`locals`)
Locals allow you to assign a name to an expression, so you can use it multiple times without repeating the expression.
```hcl
locals {
  common_tags = {
    Owner       = "Engineering Team"
    Environment = "Production"
  }
}
```
Reference with `local.common_tags`.

---
**Why this matters**: Hardcoding is a huge anti-pattern in Terraform. To write maintainable IaC, you must build configurations that can be deployed to `us-east-1` and `eu-west-1` just by changing variable inputs!

Go to `assignment/README.md` to begin your hands-on work.
