terraform {
      
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0"
    }
  }
  
  # Comment this out for first run, uncomment after backend is created
  # backend "s3" {
  #   bucket         = "my-terraform-state-bucket-12345"  # Must be globally unique
  #   key            = "production/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  #   
  #   # Optional but recommended
  #   versioning = true
  # }
}

provider "aws" {
  region = var.aws_region
}