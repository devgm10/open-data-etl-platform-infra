module "vpc" {
    count  = var.enable_vpc ? 1 : 0
    source = "./modules/vpc"

    name = "open-data-etl-platform-dev"

    vpc_cidr = "10.0.0.0/16"

    availability_zones = [
        "us-east-2a",
        "us-east-2b",
    ]

    public_subnet_cidrs = [
        "10.0.1.0/24",
        "10.0.2.0/24",
    ]

    private_subnet_cidrs = [
        "10.0.11.0/24",
        "10.0.12.0/24",
    ]
}


module "ecr" {
    source = "./modules/ecr"

    repositories = [
        "open-data-etl-platform/etl"
    ]

    tags = {
        Project     = "open-data-etl-platform"
        Environment = "lab"
        ManagedBy   = "terraform"
    }
}


module "github_ecr_oidc" {
    source = "./modules/github_ecr_oidc"

    role_name = "open-data-etl-platform-github-actions-role"

    github_subjects = [
        "repo:devgm10@230413209/open-data-etl-platform@1313458717:environment:production"
    ]

    ecr_repository_arns = values(module.ecr.repository_arns)

    tags = {
        Project     = "open-data-etl-platform"
        Environment = "lab"
        ManagedBy   = "terraform"
    }
}


module "eks" {
    count  = var.enable_eks ? 1 : 0
    source = "./modules/eks"

    cluster_name    = "open-data-etl-platform-dev"
    cluster_version = "1.32"

    vpc_id             = try(module.vpc[0].vpc_id, "")
    private_subnet_ids = try(module.vpc[0].private_subnet_ids, [])

    tags = {
        Project     = "open-data-etl-platform"
        Environment = "lab"
        ManagedBy   = "terraform"
    }
}


resource "terraform_data" "validate_eks_dependencies" {
    input = local.eks_requires_vpc

    lifecycle {
        precondition {
            condition     = local.eks_requires_vpc
            error_message = "EKS requires VPC to be enabled. Set enable_vpc = true when enable_eks = true."
        }
    }
}