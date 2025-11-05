variable "aws_region" {
  type = string
}

variable "instance_type" {
  type = string
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