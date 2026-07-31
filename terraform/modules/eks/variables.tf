variable "cluster_name" {
    description = "Name of the EKS cluster."
    type        = string
}

variable "cluster_version" {
    description = "Kubernetes version for the EKS cluster."
    type        = string
}

variable "vpc_id" {
    description = "VPC ID where the EKS cluster will be deployed."
    type        = string
}

variable "private_subnet_ids" {
    description = "Private subnet IDs used by the EKS cluster and node groups."
    type        = list(string)
}

variable "tags" {
    description = "Common tags for EKS resources."
    type        = map(string)
    default     = {}
}