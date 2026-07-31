variable "aws_region" {
    description = "AWS region where the development infrastructure will be deployed."
    type        = string
    default     = "us-east-2"
}

variable "enable_vpc" {
    description = "Enable creation of the VPC networking resources."
    type        = bool
    default     = false
}

variable "enable_eks" {
    description = "Enable creation of the EKS cluster resources."
    type        = bool
    default     = false
}

locals {
    eks_requires_vpc = !var.enable_eks || var.enable_vpc
}