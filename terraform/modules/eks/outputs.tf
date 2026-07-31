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