terraform {
  cloud {
    organization = "open-data-etl-platform-org"

    workspaces {
      name = "open-data-etl-platform-infra-dev"
    }
  }

  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}