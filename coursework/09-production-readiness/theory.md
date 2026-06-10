# Module 9: Production Readiness

You now know how to build advanced, secure architecture using custom VPCs. But writing code on your laptop is only half the battle. In a real DevOps environment, you need to manage multiple environments (Dev, Staging, Prod) and automate your deployments.

## 1. Workspaces
Right now, if you change `instance_type` from `t3.micro` to `t3.large`, Terraform changes your *one and only* environment.
What if you want a `t3.micro` for your Development environment, but a `t3.large` for Production, using the exact same `main.tf` code?

Enter **Terraform Workspaces**.
A Workspace is simply a separate, isolated state file. 
- `terraform workspace new dev`: Creates a new isolated environment.
- `terraform workspace new prod`: Creates another isolated environment.

In your code, you can use the built-in variable `terraform.workspace` to dynamically change infrastructure based on the environment!
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345"
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"
}
```

## 2. Static Security Analysis (`tfsec` / `trivy`)
Before you push your code, how do you know if you accidentally left an S3 bucket public, or if you opened port 22 to `0.0.0.0/0` in a Security Group?
**tfsec** (now part of Aqua Trivy) is a tool that scans your `.tf` files for security misconfigurations *before* you deploy them. It acts as an automated security auditor.

## 3. CI/CD Automation
In modern DevOps, engineers almost *never* run `terraform apply` from their laptops. It is too dangerous.
Instead, we use pipelines (like GitHub Actions, GitLab CI, or Jenkins).
- **Pull Request**: When you open a PR, GitHub automatically runs `terraform plan` and posts the plan as a comment on the PR.
- **Merge to Main**: When the Tech Lead approves the PR and merges it, GitHub automatically runs `terraform apply` to deploy the infrastructure.
