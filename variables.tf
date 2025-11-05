variable "aws_region" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "state_bucket_name" {
  type        = string
  description = "The name of the S3 bucket for Terraform state storage."  
}