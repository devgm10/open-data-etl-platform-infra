data "tls_certificate" "github" {
    url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
    url = "https://token.actions.githubusercontent.com"

    client_id_list = [
        "sts.amazonaws.com"
    ]

    thumbprint_list = [
        data.tls_certificate.github.certificates[0].sha1_fingerprint
    ]

    tags = merge(
        var.tags,
        {
            Name = "github-actions-oidc"
        }
    )
}

data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"

        actions = [
            "sts:AssumeRoleWithWebIdentity"
        ]

        principals {
            type = "Federated"
            identifiers = [
                aws_iam_openid_connect_provider.github.arn
            ]
        }

        condition {
            test     = "StringEquals"
            variable = "token.actions.githubusercontent.com:aud"
            values = [
                "sts.amazonaws.com"
            ]
        }

        condition {
            test     = "StringLike"
            variable = "token.actions.githubusercontent.com:sub"
            values = [
                "repo:${var.github_repository}:ref:refs/heads/${var.github_branch}",
                "repo:${var.github_repository}:environment:${var.github_environment}"
            ]
        }
    }
}

resource "aws_iam_role" "this" {
    name = var.role_name

    assume_role_policy = data.aws_iam_policy_document.assume_role.json

    tags = merge(
        var.tags,
        {
            Name = var.role_name
        }
    )
}

data "aws_iam_policy_document" "ecr_push" {
    statement {
        effect = "Allow"

        actions = [
            "ecr:GetAuthorizationToken"
        ]

        resources = ["*"]
    }

    statement {
        effect = "Allow"

        actions = [
            "ecr:BatchCheckLayerAvailability",
            "ecr:CompleteLayerUpload",
            "ecr:DescribeImages",
            "ecr:DescribeRepositories",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart"
        ]

        resources = var.ecr_repository_arns
    }
}

resource "aws_iam_policy" "ecr_push" {
    name        = "${var.role_name}-ecr-push"
    description = "Allow GitHub Actions to push Docker images to selected ECR repositories."

    policy = data.aws_iam_policy_document.ecr_push.json

    tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecr_push" {
    role       = aws_iam_role.this.name
    policy_arn = aws_iam_policy.ecr_push.arn
}