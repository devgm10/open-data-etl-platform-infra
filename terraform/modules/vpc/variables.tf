variable "name" {
    description = "Name prefix for the VPC resources."
    type        = string
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC."
    type        = string
    default     = "10.0.0.0/16"

}

variable "availability_zones" {
    description = "Availability zones where the VPC subnets will be created."
    type        = list(string)
}

variable "public_subnet_cidrs" {
    description = "CIDR blocks for public subnets."
    type        = list(string)
}

variable "private_subnet_cidrs" {
    description = "CIDR blocks for private subnets."
    type        = list(string)
}