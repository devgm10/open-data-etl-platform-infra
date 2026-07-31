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