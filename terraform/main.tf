# module "vpc" {
#   source = "./modules/vpc"
#
#   name = "open-data-etl-platform-dev"
#
#   vpc_cidr = "10.0.0.0/16"
#
#   availability_zones = [
#     "us-east-2a",
#     "us-east-2b",
#   ]
#
#   public_subnet_cidrs = [
#     "10.0.1.0/24",
#     "10.0.2.0/24",
#   ]
#
#   private_subnet_cidrs = [
#     "10.0.11.0/24",
#     "10.0.12.0/24",
#   ]
# }


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

    github_repository = "devgm10/open-data-etl-platform"
    github_branch     = "main"
    github_environment = "production"

    ecr_repository_arns = values(module.ecr.repository_arns)

    tags = {
        Project     = "open-data-etl-platform"
        Environment = "lab"
        ManagedBy   = "terraform"
    }
}