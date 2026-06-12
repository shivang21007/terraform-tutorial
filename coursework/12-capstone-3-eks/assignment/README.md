# Capstone 3: Deploying EKS

Your goal is to write the Terraform code to deploy a production-grade Amazon EKS cluster with managed node groups.

## Instructions

We will not be writing custom modules for this. Instead, you will use the official Terraform AWS Registry modules for the VPC and EKS to see how the industry relies on community standards.

Create your `main.tf` file and complete the following:

### 1. Provider Configuration
- Set the AWS provider region to `us-east-1`.

### 2. Local Variables
- Create a `locals` block.
- Define a local variable called `cluster_name` and set it to `"capstone3-eks-cluster"`.

### 3. The VPC (The Foundation)
Use the `terraform-aws-modules/vpc/aws` module.
- `name` = `"eks-vpc"`
- `cidr` = `"10.0.0.0/16"`
- `azs` = `["us-east-1a", "us-east-1b"]`
- `private_subnets` = `["10.0.1.0/24", "10.0.2.0/24"]`
- `public_subnets` = `["10.0.101.0/24", "10.0.102.0/24"]`
- `enable_nat_gateway` = `true`
- `single_nat_gateway` = `true` (to save costs!)
- `enable_dns_hostnames` = `true`

**CRITICAL TAGS**:
- On the VPC: `kubernetes.io/cluster/${local.cluster_name}` = `"shared"`
- On `public_subnet_tags`: `kubernetes.io/role/elb` = `1`
- On `private_subnet_tags`: `kubernetes.io/role/internal-elb` = `1`

### 4. The EKS Cluster
Use the `terraform-aws-modules/eks/aws` module (version `~> 21.0`).
- `name` = `local.cluster_name`
- `kubernetes_version` = `"1.34"`
- `endpoint_public_access` = `true` (so you can run kubectl from your laptop)
- `vpc_id` = reference your VPC module output! (Hint: `module.vpc.vpc_id`)
- `subnet_ids` = reference your private subnets from the VPC module!
- `enable_cluster_creator_admin_permissions` = `true` (This replaces `manage_aws_auth_configmap` to give your AWS user access to the cluster)
- `addons` = `{ coredns = {}, kube-proxy = { before_compute = true }, vpc-cni = { before_compute = true } }` (Required in v21+ to provide a network for your nodes)

### 5. Managed Node Groups
Inside your EKS module block, define the `eks_managed_node_groups` map:
```hcl
eks_managed_node_groups = {
  general = {
    desired_size = 2
    min_size     = 1
    max_size     = 3

    instance_types = ["t3.small"] # t3.small is sufficient and Free Tier eligible!
    capacity_type  = "ON_DEMAND"
  }
}
```

### 6. Outputs
Create an `outputs.tf` file and export:
- The cluster endpoint: `module.eks.cluster_endpoint`
- The cluster OIDC provider ARN: `module.eks.oidc_provider_arn`

### 7. Run Apply
Run `terraform init` and `terraform apply`.
**Warning: EKS takes about 15-20 minutes to provision. Be very patient!**

### 8. Connect to the Cluster
Once applied, update your local `kubeconfig` by running:
`aws eks --region us-east-1 update-kubeconfig --name capstone3-eks-cluster`

Then run `kubectl get nodes` to verify your worker nodes are ready!
