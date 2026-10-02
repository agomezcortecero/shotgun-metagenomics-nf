# ==============================================================================
# Terraform Infrastructure as Code (IaC) for AWS Batch & S3 Nextflow Setup
# ==============================================================================

terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --- S3 Storage for Work Directory and Pipeline Results ---
resource "aws_s3_bucket" "nextflow_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = false

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Metagenomics"
  }
}

# --- IAM Roles for AWS Batch & ECS ---
resource "aws_iam_role" "aws_batch_service_role" {
  name = "nextflow_aws_batch_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "batch.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role_attach" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "nextflow_ecs_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "s3_full_access_attach" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "nextflow_ecs_instance_profile"
  role = aws_iam_role.ecs_instance_role.name
}

# --- Security Group ---
resource "aws_security_group" "batch_sg" {
  name        = "nextflow_batch_sg"
  description = "Security group for AWS Batch compute environment"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- AWS Batch Compute Environment ---
resource "aws_batch_compute_environment" "metagenomics_spot_env" {
  compute_environment_name = "metagenomics-spot-env"
  type                     = "MANAGED"
  service_role             = aws_iam_role.aws_batch_service_role.arn

  compute_resources {
    type                = "SPOT"
    allocation_strategy = "BEST_FIT_PROGRESSIVE"
    max_vcpus           = var.max_vcpus
    min_vcpus           = 0
    instance_type       = ["optimal", "c5", "m5", "r5"]
    subnets             = var.subnet_ids
    security_group_ids  = [aws_security_group.batch_sg.id]
    instance_role       = aws_iam_instance_profile.ecs_instance_profile.arn
  }

  depends_on = [aws_iam_role_policy_attachment.aws_batch_service_role_attach]
}

# --- AWS Batch Job Queue ---
resource "aws_batch_job_queue" "metagenomics_queue" {
  name                 = "metagenomics-batch-queue"
  state                = "ENABLED"
  priority             = 1
  compute_environments = [aws_batch_compute_environment.metagenomics_spot_env.arn]
}
