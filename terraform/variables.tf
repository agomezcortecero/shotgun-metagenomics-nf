variable "aws_region" {
  description = "AWS Region to deploy infrastructure"
  type        = string
  default     = "eu-south-2"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "production"
}

variable "s3_bucket_name" {
  description = "Unique S3 bucket name for Nextflow data and work directories"
  type        = string
  default     = "metagenomics-nextflow-bucket-demo"
}

variable "vpc_id" {
  description = "Target VPC ID"
  type        = string
  default     = "vpc-12345678"
}

variable "subnet_ids" {
  description = "List of Subnet IDs for EC2 Batch instances"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"]
}

variable "max_vcpus" {
  description = "Maximum vCPUs for Batch compute environment"
  type        = number
  default     = 256
}
