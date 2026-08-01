# EKS Operations Guide

## Purpose

This document defines the operational procedure for enabling, accessing, validating, and disabling the EKS environment used by the Open Data ETL Platform lab.

The platform is designed to remain in a cost-safe mode by default. EKS and networking resources that generate cost should only be enabled when actively testing the Kubernetes environment.

---

## Current cost-safe mode

By default, the Terraform Cloud workspace variables should remain as:

```hcl
enable_vpc = false
enable_eks = false
```

This keeps the following resources active:

- Amazon ECR repository
- GitHub Actions IAM Role
- GitHub OIDC Provider
- ECR push/read IAM policy
- Terraform state validation resources

This keeps the following cost-generating resources disabled:

- Custom VPC
- NAT Gateway
- Elastic IP for NAT
- EKS Cluster
- EC2 worker nodes
- Load Balancers

---

## Terraform Cloud workspace variables

The following variables are managed in Terraform Cloud:

```hcl
enable_vpc = false
enable_eks = false
```

They must be configured as:

```text
Category: Terraform variable
HCL: true
Sensitive: false
```

Normal safe state:

```hcl
enable_vpc = false
enable_eks = false
```

Temporary EKS testing state:

```hcl
enable_vpc = true
enable_eks = true
```

---

## Enable EKS temporarily

To deploy the Kubernetes platform, update the Terraform Cloud workspace variables:

```hcl
enable_vpc = true
enable_eks = true
```

Then run and apply the Terraform Cloud plan.

Expected resources to be created:

- VPC
- Public subnets
- Private subnets
- Internet Gateway
- NAT Gateway
- Elastic IP for NAT
- Public route table
- Private route table
- Route table associations
- EKS Cluster
- EKS Managed Node Group
- IAM role for EKS control plane
- IAM role for EKS worker nodes
- IAM policy attachments for EKS

Expected plan summary should look similar to:

```text
Plan: 22 to add, 0 to change, 0 to destroy.
```

Do not apply the plan if it includes unexpected destroy actions.

---

## Connect to the EKS cluster

After the cluster is active, configure the local kubeconfig:

```bash
aws eks update-kubeconfig \
  --region us-east-2 \
  --name open-data-etl-platform-dev
```

Verify the connection:

```bash
kubectl get nodes
kubectl get namespaces
kubectl cluster-info
```

Expected result:

- At least one worker node should appear.
- The default Kubernetes namespaces should be listed.
- The Kubernetes control plane endpoint should be reachable.

---

## Validate EKS resources

Useful validation commands:

```bash
aws eks describe-cluster \
  --region us-east-2 \
  --name open-data-etl-platform-dev
```

```bash
aws eks list-nodegroups \
  --region us-east-2 \
  --cluster-name open-data-etl-platform-dev
```

```bash
kubectl get nodes -o wide
```

```bash
kubectl get pods -A
```

---

## Disable EKS after testing

To stop cost-generating resources, update the Terraform Cloud workspace variables back to:

```hcl
enable_vpc = false
enable_eks = false
```

Then run and apply the Terraform Cloud plan.

Expected resources to be destroyed:

- EKS Managed Node Group
- EKS Cluster
- EKS IAM roles
- NAT Gateway
- Elastic IP for NAT
- Public subnets
- Private subnets
- Route tables
- Route table associations
- Internet Gateway
- VPC

Expected resources to remain:

- Amazon ECR repository
- GitHub Actions IAM Role
- GitHub OIDC Provider
- ECR push/read IAM policy
- Terraform state validation resources

---

## Cost warning

Do not leave the following resources running when the lab is not being actively tested:

- NAT Gateway
- EKS Cluster
- EC2 worker nodes
- Load Balancers

The normal resting state of the lab should always be:

```hcl
enable_vpc = false
enable_eks = false
```

---

## Recommended workflow

### Before testing EKS

1. Confirm Terraform Cloud variables:

```hcl
enable_vpc = true
enable_eks = true
```

2. Review the Terraform plan.
3. Confirm there are no unexpected destroy actions.
4. Apply the plan.
5. Wait for EKS and node group creation to complete.

### During testing

Configure kubeconfig:

```bash
aws eks update-kubeconfig \
  --region us-east-2 \
  --name open-data-etl-platform-dev
```

Validate cluster:

```bash
kubectl get nodes
kubectl get pods -A
kubectl get namespaces
```

### After testing

1. Set Terraform Cloud variables back to:

```hcl
enable_vpc = false
enable_eks = false
```

2. Run Terraform plan.
3. Confirm Terraform plans to destroy only EKS/VPC-related resources.
4. Apply the plan.
5. Confirm AWS no longer has:

```text
NAT Gateway
EKS Cluster
EC2 worker nodes
Load Balancers
Custom VPC
Elastic IP for NAT
```

---

## Do not use full terraform destroy unless necessary

Avoid using:

```bash
terraform destroy
```

for the normal lab shutdown process.

A full destroy would also remove resources that are safe and useful to keep:

- ECR repository
- GitHub Actions IAM Role
- GitHub OIDC Provider
- ECR push/read IAM policy

The preferred shutdown mechanism is changing:

```hcl
enable_vpc = false
enable_eks = false
```

and applying the resulting Terraform Cloud plan.

---

## Current cluster defaults

Cluster name:

```text
open-data-etl-platform-dev
```

AWS region:

```text
us-east-2
```

Kubernetes version:

```text
1.32
```

Managed node group:

```text
open-data-etl-platform-dev-main-ng
```

Default node instance type:

```text
t3.small
```

Default node scaling:

```hcl
desired_size = 1
min_size     = 1
max_size     = 2
```