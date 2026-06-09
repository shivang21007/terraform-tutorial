# Terraform From Zero to Hero: Course Syllabus

Welcome to your structured Terraform learning journey! This coursework is designed to take you from basic concepts to production-grade patterns. 

As requested, this course features **Mini-Projects** to test your knowledge along the way, and culminates in a massive **Major Project** based on a real-world Product Requirements Document (PRD).

## How We Will Work Together
1. You will read the `theory.md` inside a module.
2. You will attempt the task inside the `assignment/` folder.
3. Once you finish an assignment (or get stuck), you will ping me. I will review your `.tf` files, provide constructive feedback, and grade your progress.

---

## 🗺️ Course Roadmap

### 🧱 Part 1: The Core
- **Module 01: Core Fundamentals & IaC Basics**
  - Theory: Declarative vs Imperative, Providers, The Terraform Lifecycle.
  - Assignment: Deploy a hardcoded EC2 instance.
- **Module 02: The Brain of Terraform (State Management)**
  - Theory: Local vs Remote State, Native S3 State Locking.
  - Assignment: Migrate local state to an AWS S3 backend.
- **Module 03: Making Code Dynamic**
  - Theory: Input Variables, Outputs, Data Sources.
  - Assignment: Refactor Module 01 using variables and dynamically fetch AMI IDs.
- **Module 04: Advanced HCL & Control Structures**
  - Theory: `count` vs `for_each`, Dynamic Blocks, Built-in functions.
  - Assignment: Provision multiple instances and dynamic security groups.

### 🛑 Checkpoint 1
- **Module 05: Mini-Project 1**
  - Objective: Build a load-balanced, multi-server web environment from scratch without looking at the solutions. I will evaluate your code style, security group design, and state management.

### 🏗️ Part 2: Architecture & Production Patterns
- **Module 06: Reusability with Modules**
  - Theory: Root vs Child modules, Local modules vs Terraform Registry.
  - Assignment: Build a custom, reusable VPC module.
- **Module 07: Server Configuration & Provisioning**
  - Theory: `user_data`, `local-exec`, `remote-exec`.
  - Assignment: Deploy a highly available Nginx web server cluster.
- **Module 08: Real-World State Manipulation**
  - Theory: `terraform state list/rm/mv`, fixing drift, `terraform import`.
  - Assignment: Import a manually created S3 bucket into Terraform code.
- **Module 09: Production Readiness (Workspaces & CI/CD)**
  - Theory: Workspaces, GitHub Actions automation, tfsec.
  - Assignment: Write a GitHub Actions workflow for automated plans.

### 🚀 Checkpoint 2
- **Module 10: The Major Project (Final Exam)**
  - Objective: You will be handed a PRD for a fictional startup. You must design and provision their entire AWS infrastructure using Custom Modules, Remote State Locking, ALB, ASG, and VPCs. I will act as the Senior Architect reviewing your PR.
