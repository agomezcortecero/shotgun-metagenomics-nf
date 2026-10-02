# Infrastructure as Code (IaC) - AWS Batch & S3 Setup

This directory contains Terraform scripts to automatically provision the AWS infrastructure required to execute Nextflow pipelines at scale.

## Provisioned Resources:
- **Amazon S3 Bucket:** For input reads, intermediate `workDir`, and output data.
- **AWS Batch Compute Environment:** Auto-scaling Spot EC2 instances (`c5`, `m5`, `r5`).
- **AWS Batch Job Queue:** Priority queue connected to Nextflow (`metagenomics-batch-queue`).
- **IAM Roles & Security Groups:** Secure credentials for EC2 container execution and S3 read/write.

## How to Deploy:
1. Ensure `terraform` and `aws-cli` are installed and authenticated:
   ```bash
   aws configure
   ```
2. Initialize and apply Terraform:
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```
3. Use the generated queue name and S3 bucket in your `nextflow.config` or run script!
