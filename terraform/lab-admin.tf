resource "aws_iam_user" "lab_admin" {
    name = "open-data-etl-platform-admin"

    tags = {
        Project     = "open-data-etl-platform"
        Environment = "lab"
        ManagedBy   = "terraform"
        Name        = "open-data-etl-platform-admin"
    }
}

data "aws_iam_policy_document" "lab_admin_eks_access" {
    statement {
        effect = "Allow"

        actions = [
            "eks:DescribeCluster",
            "eks:ListClusters"
        ]

        resources = [
            "*"
        ]
    }
}

resource "aws_iam_policy" "lab_admin_eks_access" {
    name        = "open-data-etl-platform-admin-eks-access"
    description = "Allow the lab admin IAM user to discover and connect to EKS clusters."

    policy = data.aws_iam_policy_document.lab_admin_eks_access.json

    tags = {
        Project     = "open-data-etl-platform"
        Environment = "lab"
        ManagedBy   = "terraform"
    }
}

resource "aws_iam_user_policy_attachment" "lab_admin_eks_access" {
    user       = aws_iam_user.lab_admin.name
    policy_arn = aws_iam_policy.lab_admin_eks_access.arn
}