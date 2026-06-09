# Terraform From Zero to Hero: Course Syllabus

Welcome to your structured Terraform learning journey! This coursework is designed to take you from basic concepts to production-grade patterns. 

As requested, this course features **Mini-Projects** to test your knowledge along the way, and culminates in **Two Major Capstone Projects**, including deploying a production-grade EKS cluster from scratch!

## How We Will Work Together
1. You will read the `theory.md` inside a module.
2. You will attempt the task inside the `assignment/` folder.
3. Once you finish an assignment (or get stuck), you will ping me. I will review your `.tf` files, provide constructive feedback, and grade your progress.

---

## 🗺️ Course Roadmap

### 🧱 Part 1: The Core
- **Module 01: Core Fundamentals & IaC Basics** *(Completed!)*
  - Theory: Declarative vs Imperative, Providers, The Terraform Lifecycle.
  - Assignment: Deploy a hardcoded EC2 instance.
- **Module 02: The Brain of Terraform (State Management)** *(Completed!)*
  - Theory: Local vs Remote State, Native S3 State Locking.
  - Assignment: Migrate local state to an AWS S3 backend.
- **Module 03: Making Code Dynamic** *(Completed!)*
  - Theory: Input Variables, Outputs, Data Sources.
  - Assignment: Refactor Module 01 using variables and dynamically fetch AMI IDs.
- **Module 04: Advanced HCL & Control Structures** *(Completed!)*
  - Theory: `count` vs `for_each`, Dynamic Blocks, Built-in functions.
  - Assignment: Provision multiple instances and dynamic security groups.

### 🏗️ Part 2: Architecture & Production Patterns
- **Module 05: Reusability with Modules** *(Completed!)*
  - Theory: Root vs Child modules, Local modules vs Terraform Registry.
  - Assignment: Build a custom, reusable EC2 server module.
- **Module 06: Mini-Project 1 - The Web Tier** *(Completed!)*
  - Objective: Combine everything from Part 1 & 2 to deploy a scalable Web Tier from scratch without step-by-step handholding.
- **Module 07: State Manipulation & Provisioners** *(Next!)*
  - Theory: `terraform state rm/mv`, fixing drift, `terraform import`, `local-exec`, `remote-exec`.
  - Assignment: Import a manually created S3 bucket into Terraform code and use a local provisioner.
- **Module 08: Networking Deep Dive**
  - Theory: Building AWS networking infrastructure completely from scratch without using official modules.
  - Assignment: Build a VPC, Public/Private Subnets, Internet Gateway, and Route Tables.

- **Module 09: Production Readiness (Workspaces & CI/CD)**
  - Theory: Terraform Workspaces, GitHub Actions automation, and `tfsec` for security scanning.
  - Assignment: Write a GitHub Actions workflow for automated plans and apply security scanning.

### 🚀 Checkpoint: The Final Exams (Three Capstones)
- **Module 10: Capstone 1 - The Startup PRD**
  - Objective: You will be handed a PRD for a fictional startup. You must design and provision their entire AWS infrastructure using Custom Modules, Remote State Locking, ALB, ASG, and your custom VPC. I will act as the Senior Architect reviewing your PR.
- **Module 11: Capstone 2 - Multi-Tier Architecture**
  - Objective: Deploy a full 3-tier application (Frontend, Backend, Database) using strict security group rules and private subnets.
- **Module 12: Capstone 3 - EKS Cluster Deployment**
  - Objective: The ultimate DevOps interview challenge. You will build and deploy a production-ready AWS Elastic Kubernetes Service (EKS) cluster using Terraform, including worker node groups and IAM OIDC providers.
