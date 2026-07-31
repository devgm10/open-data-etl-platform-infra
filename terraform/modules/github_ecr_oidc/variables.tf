variable "role_name" {
    description = "IAM role name for GitHub Actions."
    type        = string
}

variable "ecr_repository_arns" {
    description = "List of ECR repository ARNs where GitHub Actions can push images."
    type        = list(string)
}

variable "tags" {
    description = "Common tags for IAM resources."
    type        = map(string)
    default     = {}
}

variable "github_subjects" {
    description = "GitHub OIDC subjects allowed to assume the IAM role."
    type        = list(string)
}