# Module 1: Core Fundamentals & IaC Basics

## 1. What is Infrastructure as Code (IaC)?
Historically, if a company needed a new server, a SysAdmin had to rack physical hardware, install the OS, configure networking, and manually install software. When the cloud (AWS/GCP/Azure) arrived, this turned into clicking around a web console. 

**Infrastructure as Code (IaC)** replaces manual clicking with code. You write a script defining what you want, and the tool builds it. 

There are two paradigms of IaC:
- **Imperative (e.g., Bash Scripts, AWS CLI):** You tell the system *how* to do it. ("Create a server, wait 10 seconds, attach a volume"). If you run it twice, it might fail or create a duplicate server!
- **Declarative (e.g., Terraform):** You tell the system *what* you want. ("I want 1 server with 1 volume"). Terraform figures out how to make that reality. If you run it twice, Terraform sees the server already exists and does nothing.

## 2. Terraform Architecture
Terraform has two main parts:
1. **Terraform Core:** The binary you installed. It reads your `.tf` files, reads the state, compares them, and generates an execution plan.
2. **Providers:** Terraform Core doesn't know how to talk to AWS. It relies on "Providers" (plugins) downloaded during `terraform init`. Providers translate Terraform code into API calls to AWS, Azure, Google Cloud, GitHub, etc.

## 3. The Terraform Lifecycle
You will run these commands hundreds of times. Memorize them:

1. `terraform init`
   - **What it does:** Initializes the working directory.
   - **Behind the scenes:** Downloads provider plugins (like the AWS provider) into a hidden `.terraform/` folder and initializes the state backend.
2. `terraform plan`
   - **What it does:** Shows you what *will* happen.
   - **Behind the scenes:** Compares your `.tf` files to your `terraform.tfstate` (and checks the actual cloud) to determine the "diff" (what needs to be created, updated, or destroyed).
3. `terraform apply`
   - **What it does:** Executes the plan.
   - **Behind the scenes:** Calls the AWS API to create the resources and writes the new infrastructure mapping to your `terraform.tfstate` file.
4. `terraform destroy`
   - **What it does:** Deletes everything managed by this specific Terraform project.

## 4. HCL Syntax Basics
HashiCorp Configuration Language (HCL) consists of **Blocks**. The most important block is the `resource` block.

```hcl
# Block Type | Provider_ResourceType | Resource Name (Internal to Terraform)
resource       "aws_instance"          "my_web_server" {
  
  # Arguments (Specific to the resource type)
  ami           = "ami-123456"
  instance_type = "t2.micro"

}
```

---

## 🎯 Next Steps
Head over to the `assignment/` directory for your very first challenge!
