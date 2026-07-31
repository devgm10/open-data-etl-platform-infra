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

variable "node_instance_types" {
    description = "EC2 instance types used by the EKS managed node group."
    type        = list(string)
    default     = ["t3.small"]
}

variable "node_desired_size" {
    description = "Desired number of worker nodes."
    type        = number
    default     = 1
}

variable "node_min_size" {
    description = "Minimum number of worker nodes."
    type        = number
    default     = 1
}

variable "node_max_size" {
    description = "Maximum number of worker nodes."
    type        = number
    default     = 2
}

variable "tags" {
    description = "Common tags for EKS resources."
    type        = map(string)
    default     = {}
}