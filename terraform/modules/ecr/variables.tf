variable "repositories" {
    description = "List of ECR repositories to create."
    type        = list(string)
}

variable "image_tag_mutability" {
    description = "Image tag mutability configuration for ECR repositories."
    type        = string
    default     = "MUTABLE"
    }

variable "scan_on_push" {
    description = "Enable image scanning on push."
    type        = bool
    default     = true
}

variable "tags" {
    description = "Common tags for ECR repositories."
    type        = map(string)
    default     = {}
}