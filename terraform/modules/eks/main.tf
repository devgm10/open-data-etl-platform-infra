data "aws_iam_policy_document" "eks_cluster_assume_role" {
    statement {
        effect = "Allow"

        actions = [
            "sts:AssumeRole"
        ]

        principals {
            type = "Service"

            identifiers = [
                "eks.amazonaws.com"
            ]
        }
    }
}

resource "aws_iam_role" "cluster" {
    name = "${var.cluster_name}-cluster-role"

    assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

    tags = merge(
        var.tags,
        {
            Name = "${var.cluster_name}-cluster-role"
        }
    )
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
    role       = aws_iam_role.cluster.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy_document" "eks_node_assume_role" {
    statement {
        effect = "Allow"

        actions = [
            "sts:AssumeRole"
        ]

        principals {
            type = "Service"

            identifiers = [
                "ec2.amazonaws.com"
            ]
        }
    }
}

resource "aws_iam_role" "node" {
    name = "${var.cluster_name}-node-role"

    assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json

    tags = merge(
        var.tags,
        {
            Name = "${var.cluster_name}-node-role"
        }
    )
}

resource "aws_iam_role_policy_attachment" "node_worker_policy" {
    role       = aws_iam_role.node.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_cni_policy" {
    role       = aws_iam_role.node.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_ecr_readonly_policy" {
    role       = aws_iam_role.node.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "this" {
    name     = var.cluster_name
    version  = var.cluster_version
    role_arn = aws_iam_role.cluster.arn

    vpc_config {
        subnet_ids              = var.private_subnet_ids
        endpoint_private_access = true
        endpoint_public_access  = true
    }

    depends_on = [
        aws_iam_role_policy_attachment.cluster_policy
    ]

    tags = merge(
        var.tags,
        {
            Name = var.cluster_name
        }
    )
}

resource "aws_eks_node_group" "main" {
    cluster_name    = aws_eks_cluster.this.name
    node_group_name = "${var.cluster_name}-main-ng"
    node_role_arn   = aws_iam_role.node.arn
    subnet_ids      = var.private_subnet_ids

    instance_types = var.node_instance_types

    scaling_config {
        desired_size = var.node_desired_size
        min_size     = var.node_min_size
        max_size     = var.node_max_size
    }

    update_config {
        max_unavailable = 1
    }

    depends_on = [
        aws_iam_role_policy_attachment.node_worker_policy,
        aws_iam_role_policy_attachment.node_cni_policy,
        aws_iam_role_policy_attachment.node_ecr_readonly_policy
    ]

    tags = merge(
        var.tags,
        {
            Name = "${var.cluster_name}-main-ng"
        }
    )
}