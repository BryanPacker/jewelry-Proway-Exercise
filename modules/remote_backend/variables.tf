variable "aws_region" {
  type = string
  description = "The AWS region to deploy resources in."
}

variable "lock_table_name" {
  type        = string
  description = "The name of the DynamoDB table for Terraform state locking."
  default     = "terraform-state-lock"
}

variable "state_bucket_name" {
  type        = string
  description = "The name of the S3 bucket for Terraform state storage."  
}