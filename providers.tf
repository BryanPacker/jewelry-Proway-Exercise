terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0"
    }
  }
  # Comment this out for first run, uncomment after backend is created
   backend "s3" {
     bucket         = "jewerly-terraform-state-bucket-05112025"  # Must be globally unique
     key            = "production/terraform.tfstate"
     region         = "us-east-1"
     encrypt        = true
     use_lockfile   = true
   }
   
  }
provider "aws" {
  region = var.aws_region
}