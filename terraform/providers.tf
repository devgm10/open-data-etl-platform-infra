terraform {
    cloud {
        organization = "open-data-etl-platform-lab"

        workspaces {
            name = "open-data-etl-platform-infra"
        }
    }

    required_version = ">= 1.9.0"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }

        tls = {
            source  = "hashicorp/tls"
            version = "~> 4.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
}