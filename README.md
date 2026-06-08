# Terraform Learning Journey

Welcome to my Terraform learning repository! This project serves as a practical sandbox where I am learning, experimenting with, and documenting various Terraform concepts—from basic AWS provisioning to advanced state management.

## 🎯 Objectives
- Understand Terraform core concepts (State, Providers, Resources, Variables, Outputs).
- Practice provisioning AWS infrastructure (EC2, VPC, Security Groups).
- Learn about Remote State Management and Locking.
- Experiment with Terraform functions, dynamic blocks, and loops (`for_each`, `count`).

## 📂 Repository Structure

*Note: As I progress in my learning, I will be creating new folders to isolate different projects and concepts.*

### Current Sandbox (Root Directory)
Right now, the root files (`ec2.tf`, `variables.tf`, `outputs.tf`) house my initial practice project. It demonstrates:
- Provisioning multiple **AWS EC2 Spot Instances** using `for_each` and map variables.
- Dynamic **Security Group** rules (ingress/egress) built from list variables.
- Automated server bootstrapping via a `user_data` bash script (`installation_script.sh`) that installs and configures Nginx.

### Additional Folders
- **`key/`**: Contains a helper script (`generate_key.sh`) to quickly generate local RSA SSH key pairs for EC2 access.
- **`docs/`**: A place for my personal technical notes.
  - [`remote-lock.md`](./docs/remote-lock.md): Detailed notes explaining how Terraform remote state and locking works (S3 + DynamoDB vs. S3 Native Locking).

## 🛠️ Prerequisites

To run any of the experiments in this repository, you need:
1. **Terraform** installed on your local machine.
2. **AWS CLI** installed and configured with your credentials (`aws configure`).
3. An **SSH Key Pair** (You can use the script inside the `key/` folder to generate one).

## 🚀 General Workflow

When practicing in any folder, the standard Terraform workflow applies:

```bash
terraform init      # Initialize the provider and download plugins
terraform fmt       # Auto-format the code for readability
terraform validate  # Check for syntax and configuration errors
terraform plan      # Preview what infrastructure will be created/changed
terraform apply     # Deploy the infrastructure to AWS
terraform destroy   # Tear down everything to avoid cloud charges!
```

## ⚠️ Important Notes
- **Security:** My `.gitignore` is set up to ignore `.terraform/` directories, `*.tfstate` files, and private `*.pem` keys. Never commit state files, as they can contain sensitive credentials in plain text.
- **Cost Management:** To keep my AWS bill at zero while learning, I  always remember to run `terraform destroy` when my practice session is over.
