provider "aws" {
    region = "ap-southeast-1"  # Singapore region
  }

  # Create the EKS cluster
  resource "aws_eks_cluster" "kube_node" {
    name     = "kube-node"
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {
      security_group_ids = [aws_security_group.eks_cluster_sg.id]
      subnet_ids         = [
        aws_subnet.public_subnet_1.id,
        aws_subnet.public_subnet_2.id
      ]
      endpoint_private_access = false
      endpoint_public_access  = true
    }

    # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling
    depends_on = [
      aws_iam_role_policy_attachment.eks_cluster_policy
    ]
  }

  # Create a node group for the EKS cluster
  resource "aws_eks_node_group" "kube_node_group" {
    cluster_name    = aws_eks_cluster.kube_node.name
    node_group_name = "kube-node-group"
    node_role_arn   = aws_iam_role.eks_node_role.arn
    subnet_ids      = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]

    scaling_config {
      desired_size = 2
      max_size     = 2
      min_size     = 1
    }

    instance_types = ["t3.micro"]  # You can change this to your preferred instance type

    depends_on = [
      aws_iam_role_policy_attachment.eks_worker_node_policy,
      aws_iam_role_policy_attachment.eks_cni_policy,
      aws_iam_role_policy_attachment.eks_container_registry_policy,
    ]
  }

  # Output values
  output "eks_cluster_endpoint" {
    description = "Endpoint for EKS cluster"
    value       = aws_eks_cluster.kube_node.endpoint
  }

  output "eks_cluster_certificate_authority" {
    description = "Certificate authority data for EKS cluster"
    value       = aws_eks_cluster.kube_node.certificate_authority[0].data
  }

  output "kubectl_config_command" {
    description = "Command to configure kubectl"
    value       = "aws eks update-kubeconfig --name kube-node --region ap-southeast-1"
  }