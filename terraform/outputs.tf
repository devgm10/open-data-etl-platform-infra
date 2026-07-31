# output "vpc_id" {
#   description = "ID of the VPC."
#   value       = module.vpc.vpc_id
# }

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