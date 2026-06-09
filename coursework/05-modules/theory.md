# Module 5: Terraform Modules

You just learned that Terraform only looks at the `.tf` files in your current working directory. So how do you organize a large codebase? Or reuse a standard server configuration across your `dev` and `prod` environments? 

The answer is **Modules**.

## What is a Module?
A module is simply a container for multiple resources that are used together. In fact, every Terraform configuration you've written so far has been a module! The directory you run `terraform apply` in is called the **Root Module**. 

When you call another module from your Root Module, that called module is referred to as a **Child Module**.

## Calling a Local Child Module
To use a module, you use the `module` block and point the `source` to the directory containing the `.tf` files you want to use.

```hcl
module "my_web_server" {
  source = "./modules/web-server"
}
```
When you run `terraform init`, Terraform will see this block and pull the code from `./modules/web-server` into your project.

## Passing Inputs to Modules
Child modules often require input variables to be flexible (just like passing arguments to a function in a programming language). If the child module has a `variable "instance_type"`, you pass it in like this:

```hcl
module "my_web_server" {
  source        = "./modules/web-server"
  instance_type = "t3.large"
  server_name   = "Prod-Web"
}
```

## Getting Outputs from Modules
If your child module creates an EC2 instance and outputs its IP address in an `outputs.tf` file, you can access that output in your Root Module using `module.<MODULE_NAME>.<OUTPUT_NAME>`.

```hcl
output "web_ip" {
  value = module.my_web_server.public_ip
}
```

## The Terraform Registry (Public Modules)
You don't always have to write your own modules. AWS, Google, and the community have published thousands of pre-built, production-ready modules on the [Terraform Registry](https://registry.terraform.io/).

For example, to securely provision an entire AWS VPC with public subnets, private subnets, and NAT gateways, you don't need to write 500 lines of code. You can just use the official AWS VPC module:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
}
```

---
**Why this matters**: Modules are the standard way to build Infrastructure as Code. In professional environments, you rarely write raw `aws_instance` resources in your root directory. Instead, platform teams write secure, compliant child modules, and application teams consume them!

Go to `assignment/README.md` to build your first module.
