# Open Data ETL Platform Infrastructure

Infrastructure as Code and Kubernetes configuration for the Open Data ETL Platform.

## Architecture

The infrastructure is designed to run the ETL platform on AWS using Kubernetes.

### Infrastructure

- Terraform
- AWS
- Amazon VPC
- Amazon ECR
- Amazon EKS

### Kubernetes

- Kubernetes
- ETL Jobs
- ETL CronJobs

## Repository Structure

```text
open-data-etl-platform-infra/
├── terraform/
│   └── environments/
│       └── dev/
│
├── kubernetes/
│
├── .gitignore
└── README.md