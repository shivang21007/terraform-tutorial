# Capstone 3: AWS Elastic Kubernetes Service (EKS)

Welcome to the final boss of this course. Deploying Kubernetes on AWS (EKS) is one of the most highly sought-after skills in DevOps and Cloud Engineering. It is also one of the most complex infrastructure components to provision correctly.

## What is EKS?
Amazon Elastic Kubernetes Service (EKS) is a managed service that you can use to run Kubernetes on AWS without needing to install, operate, and maintain your own Kubernetes control plane or nodes.

### The Two Halves of EKS
When you deploy EKS, you are deploying two distinct pieces:
1. **The Control Plane (Managed by AWS)**: This runs the Kubernetes API server, scheduler, and `etcd` database. AWS hides the EC2 instances running this from you. You just get an endpoint to communicate with the API.
2. **The Data Plane (Worker Nodes)**: These are the EC2 instances where your actual application containers (Pods) run. You manage these via **Managed Node Groups** or **Fargate**.

## The Hard Way vs The Module Way

If you were to build an EKS cluster completely from scratch using raw Terraform resources (`aws_eks_cluster`, `aws_eks_node_group`, `aws_iam_role`, etc.), it would require hundreds of lines of complex IAM policies, security group rules, and OIDC provider setups.

Instead, the industry standard is to use the official AWS EKS Terraform module (`terraform-aws-modules/eks/aws`). This module abstracts away the immense complexity while still giving you production-grade configuration options.

## Critical Requirement: VPC Tags
EKS requires your VPC and Subnets to have very specific tags so that the AWS Cloud Provider Controller running inside Kubernetes knows where it is allowed to deploy Load Balancers.

If your cluster is named `my-eks-cluster`:
- **VPC** needs: `kubernetes.io/cluster/my-eks-cluster = "shared"`
- **Public Subnets** need: `kubernetes.io/role/elb = 1` (Allows Kubernetes to create public ALBs here)
- **Private Subnets** need: `kubernetes.io/role/internal-elb = 1` (Allows Kubernetes to create internal ALBs here)

## OIDC and IAM Roles for Service Accounts (IRSA)
EKS uses OpenID Connect (OIDC) to allow Kubernetes Service Accounts to assume AWS IAM Roles. This means instead of giving your EC2 Worker Nodes broad permissions to access S3 or DynamoDB, you can grant permissions directly to specific Pods inside Kubernetes! 

When configuring the EKS module, we always ensure the OIDC provider is enabled (`enable_irsa = true`).

---
Once you are ready, head over to `assignment/README.md` to begin your final exam!
