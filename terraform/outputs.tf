output "vpc_id" {
    description = "ID of the VPC."
    value       = try(module.vpc[0].vpc_id, null)
}

output "public_subnet_ids" {
    description = "IDs of the public subnets."
    value       = try(module.vpc[0].public_subnet_ids, [])
}

output "private_subnet_ids" {
    description = "IDs of the private subnets."
    value       = try(module.vpc[0].private_subnet_ids, [])
}

output "ecr_repository_urls" {
    description = "ECR repository URLs."
    value       = module.ecr.repository_urls
}

output "ecr_repository_arns" {
    description = "ECR repository ARNs."
    value       = module.ecr.repository_arns
}

output "github_actions_role_arn" {
    description = "IAM role ARN used by GitHub Actions to push images to ECR."
    value       = module.github_ecr_oidc.role_arn
}

output "eks_cluster_name" {
    description = "Name of the EKS cluster."
    value       = try(module.eks[0].cluster_name, null)
}

output "eks_cluster_role_arn" {
    description = "IAM role ARN used by the EKS control plane."
    value       = try(module.eks[0].cluster_role_arn, null)
}

output "eks_node_role_arn" {
    description = "IAM role ARN used by the EKS managed node group."
    value       = try(module.eks[0].node_role_arn, null)
}

output "eks_cluster_endpoint" {
    description = "Endpoint for the EKS cluster API server."
    value       = try(module.eks[0].cluster_endpoint, null)
}

output "eks_cluster_arn" {
    description = "ARN of the EKS cluster."
    value       = try(module.eks[0].cluster_arn, null)
}

output "eks_node_group_name" {
    description = "Name of the EKS managed node group."
    value       = try(module.eks[0].node_group_name, null)
}

output "eks_node_group_arn" {
    description = "ARN of the EKS managed node group."
    value       = try(module.eks[0].node_group_arn, null)
}

output "aws_region" {
    description = "AWS region where the infrastructure is deployed."
    value       = var.aws_region
}