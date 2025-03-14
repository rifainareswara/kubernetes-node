#!/bin/bash
# deploy.sh - Script to deploy the EKS cluster

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Validate the Terraform configuration
echo "Validating Terraform configuration..."
terraform validate

# Plan the deployment
echo "Planning the deployment..."
terraform plan -out=tfplan

# Apply the deployment
echo "Deploying the EKS cluster..."
terraform apply tfplan

# Configure kubectl (if available)
if command -v kubectl &> /dev/null; then
    echo "Configuring kubectl to connect to the EKS cluster..."
    aws eks update-kubeconfig --name kube-node --region ap-southeast-1

    # Verify the connection
    echo "Verifying connection to the EKS cluster..."
    kubectl get nodes
else
    echo "kubectl not found. Please install kubectl to interact with your EKS cluster."
    echo "After installation, run: aws eks update-kubeconfig --name kube-node --region ap-southeast-1"
fi