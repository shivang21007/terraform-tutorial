# Terraform Commands Reference Guide

This guide provides a comprehensive overview of essential Terraform commands, their usage, and best practices.

## Basic Commands

### 1. `terraform init`
Initializes a new or existing Terraform configuration directory.

**Usage:**
```bash
terraform init [options]
```

**Common Options:**
- `-backend-config=path`: Path to backend config file
- `-reconfigure`: Reconfigure the backend
- `-upgrade`: Upgrade provider plugins to latest version

**Example:**
```bash
terraform init -backend-config="backend.hcl"
```

### 2. `terraform validate`
Validates the Terraform configuration files for syntax and internal consistency.

**Usage:**
```bash
terraform validate [options]
```

**Common Options:**
- `-json`: Output in JSON format
- `-no-color`: Disable colorized output

**Example:**
```bash
terraform validate -json
```

### 3. `terraform fmt`
Formats Terraform configuration files to a canonical format and style.

**Usage:**
```bash
terraform fmt [options] [dir]
```

**Common Options:**
- `-recursive`: Process directories recursively
- `-list=false`: Don't list files containing formatting inconsistencies
- `-write=false`: Don't write to source files

**Example:**
```bash
terraform fmt -recursive
```

### 4. `terraform plan`
Generates and shows an execution plan for the desired state of the configuration.

**Usage:**
```bash
terraform plan [options] [dir]
```

**Common Options:**
- `-out=path`: Save the plan to a file
- `-var-file=path`: Specify a variables file
- `-target=resource`: Target a specific resource
- `-destroy`: Generate a plan to destroy all resources

**Example:**
```bash
terraform plan -out=tfplan -var-file="prod.tfvars"
```

### 5. `terraform apply`
Applies the changes required to reach the desired state of the configuration.

**Usage:**
```bash
terraform apply [options] [dir]
```

**Common Options:**
- `-auto-approve`: Skip interactive approval of plan
- `-var-file=path`: Specify a variables file
- `-target=resource`: Target a specific resource
- `plan-file`: Apply a saved plan file

**Example:**
```bash
terraform apply -auto-approve -var-file="prod.tfvars"
```

### 6. `terraform destroy`
Destroys the Terraform-managed infrastructure.

**Usage:**
```bash
terraform destroy [options] [dir]
```

**Common Options:**
- `-auto-approve`: Skip interactive approval
- `-target=resource`: Target a specific resource
- `-var-file=path`: Specify a variables file

**Example:**
```bash
terraform destroy -target=aws_instance.example
```

## State Management Commands

### 7. `terraform state list`
Lists resources in the Terraform state.

**Usage:**
```bash
terraform state list [options] [pattern]
```

**Common Options:**
- `-state=path`: Path to state file
- `-id=id`: Filter by resource ID

**Example:**
```bash
terraform state list "aws_instance.*"
```

### 8. `terraform import`
Imports existing infrastructure into Terraform state.

**Usage:**
```bash
terraform import [options] ADDRESS ID
```

**Example:**
```bash
terraform import aws_instance.example i-1234567890abcdef0
```

### 9. `terraform refresh`
Updates the state file with real-world resources.

**Usage:**
```bash
terraform refresh [options] [dir]
```

**Common Options:**
- `-target=resource`: Target a specific resource
- `-var-file=path`: Specify a variables file

**Example:**
```bash
terraform refresh -target=aws_instance.example
```

## Best Practices

1. **Always use version control** for your Terraform configurations
2. **Use workspaces** to manage multiple environments
3. **Implement state locking** when working in a team
4. **Use variables** for environment-specific values
5. **Regularly run `terraform fmt`** to maintain consistent code style
6. **Always review the plan** before applying changes
7. **Use `-auto-approve`** with caution, especially in production
8. **Back up state files** regularly
9. **Use remote state storage** for team collaboration
10. **Implement proper error handling** in your configurations

## Common Workflows

### Development Workflow
```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

### Production Deployment
```bash
terraform init
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

### Resource Cleanup
```bash
terraform plan -destroy
terraform destroy -target=resource_name
```

## Troubleshooting Tips

1. If you encounter state lock issues:
   ```bash
   terraform force-unlock [LOCK_ID]
   ```

2. To check provider versions:
   ```bash
   terraform providers
   ```

3. To see detailed logs:
   ```bash
   export TF_LOG=DEBUG
   ```

4. To clean up local state:
   ```bash
   rm terraform.tfstate*
   rm .terraform.lock.hcl
   ```
