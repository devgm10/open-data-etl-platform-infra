output "cluster_name" {
    description = "Name of the EKS cluster."
    value       = var.cluster_name
}

output "cluster_role_arn" {
    description = "IAM role ARN used by the EKS control plane."
    value       = aws_iam_role.cluster.arn
}

output "node_role_arn" {
    description = "IAM role ARN used by the EKS managed node group."
    value       = aws_iam_role.node.arn
}

output "cluster_endpoint" {
    description = "Endpoint for the EKS cluster API server."
    value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
    description = "Base64 encoded certificate data required to communicate with the cluster."
    value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_arn" {
    description = "ARN of the EKS cluster."
    value       = aws_eks_cluster.this.arn
}

output "node_group_name" {
    description = "Name of the EKS managed node group."
    value       = aws_eks_node_group.main.node_group_name
}

output "node_group_arn" {
    description = "ARN of the EKS managed node group."
    value       = aws_eks_node_group.main.arn
}