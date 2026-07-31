variable "github_repository" {
    description = "GitHub repository allowed to assume the IAM role. Format: owner/repository."
    type        = string
}

variable "github_branch" {
    description = "GitHub branch allowed to assume the IAM role."
    type        = string
    default     = "main"
}

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

variable "github_environment" {
    description = "GitHub environment allowed to assume the IAM role."
    type        = string
    default     = "production"
}