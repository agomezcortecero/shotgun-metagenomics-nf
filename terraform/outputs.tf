output "s3_bucket_name" {
  description = "S3 Bucket Name for Nextflow pipelines"
  value       = aws_s3_bucket.nextflow_bucket.bucket
}

output "aws_batch_queue_name" {
  description = "AWS Batch Job Queue name"
  value       = aws_batch_job_queue.metagenomics_queue.name
}

output "aws_batch_compute_environment_arn" {
  description = "ARN of AWS Batch Compute Environment"
  value       = aws_batch_compute_environment.metagenomics_spot_env.arn
}
