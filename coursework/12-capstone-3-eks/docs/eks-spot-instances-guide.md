# EKS Production Guide: Spot Instances

This guide explains how to configure an Amazon EKS cluster to use Spot Instances securely and reliably using Terraform. By following this guide, you can reduce your Kubernetes compute costs by 70-90%.

## The "Mixed Node Group" Architecture

In a production environment, you should never run *everything* on Spot Instances. Core Kubernetes components (like CoreDNS, your Ingress Controller, or ArgoCD) should never be abruptly terminated. 

The industry best practice is to deploy **Two Node Groups**:
1. **System Node Group**: A small set of `ON_DEMAND` instances reserved strictly for critical infrastructure pods.
2. **Application Node Group**: A larger, highly scalable set of `SPOT` instances used for your actual microservices, APIs, and web apps.

---

## 1. Terraform Implementation

To implement this, you update the `eks_managed_node_groups` block in your `main.tf` to define both groups:

```hcl
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  # ... (other cluster settings)

  eks_managed_node_groups = {
    
    # 1. THE SYSTEM GROUP (Reliable, but expensive)
    system_nodes = {
      name         = "system-nodes"
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      
      # We label these nodes so we can force critical pods to run here
      labels = {
        role = "system"
      }
    }

    # 2. THE SPOT GROUP (Cheap, ephemeral, scalable)
    app_spot_nodes = {
      name         = "app-spot-nodes"
      min_size     = 2
      max_size     = 10
      desired_size = 2

      # Give AWS multiple options to find the cheapest spot pool!
      instance_types = ["t3.medium", "t3a.medium", "m5.large"]
      capacity_type  = "SPOT"

      labels = {
        role = "application"
      }
    }
  }
}
```

---

## 2. Directing Traffic (Node Affinity)

Just creating the two node groups isn't enough! By default, Kubernetes will randomly schedule Pods across all nodes. 

To ensure your critical system tools land on the `ON_DEMAND` nodes, and your web apps land on the `SPOT` nodes, you use a Kubernetes feature called **Node Affinity**.

When you write the YAML deployment for your application, you add a `nodeSelector` that matches the label we created in Terraform:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-web-app
spec:
  template:
    spec:
      # This forces the Pod to only run on your cheap Spot nodes!
      nodeSelector:
        role: application
      containers:
      - name: web
        image: nginx:latest
```

---

## 3. The AWS Node Termination Handler

Because Spot instances can be reclaimed by AWS at any time with a 2-minute warning, you must install the **AWS Node Termination Handler** in your cluster.

1. It runs as a `DaemonSet` on your cluster.
2. It constantly queries the EC2 Metadata service.
3. If it detects a "Termination Notice" from AWS, it instantly cordons the node (prevents new pods from scheduling) and drains the node (evicts existing pods so they can spin up safely on another node).

### How to install it:
You can install this directly into your cluster using Helm:
```bash
helm repo add eks https://aws.github.io/eks-charts
helm install aws-node-termination-handler eks/aws-node-termination-handler \
    --namespace kube-system
```
