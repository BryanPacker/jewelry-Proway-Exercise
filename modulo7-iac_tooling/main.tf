terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Bucket S3
resource "aws_s3_bucket" "jewelry-bucket" {
  bucket        = "jewelry-store-bucket-bryan"
  force_destroy = true
}

# Bloquear acesso público
resource "aws_s3_bucket_public_access_block" "jewelry-bucket" {
  bucket = aws_s3_bucket.jewelry-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.jewelry-bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

# CloudFront OAC
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "jewelry-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# WAF Web ACL
resource "aws_wafv2_web_acl" "cloudfront_waf" {
  name  = "jewelry-cloudfront-waf"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  # Rate Limiting: máximo 2000 requisições por IP em 5 minutos
  rule {
    name     = "rate-limit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  # Proteção contra SQL Injection, XSS, etc
  rule {
    name     = "aws-managed-rules"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "JewelryWAF"
    sampled_requests_enabled   = true
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"
  web_acl_id          = aws_wafv2_web_acl.cloudfront_waf.arn

  origin {
    domain_name              = aws_s3_bucket.jewelry-bucket.bucket_regional_domain_name
    origin_id                = "S3"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3"
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Policy S3
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.jewelry-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowCloudFront"
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.jewelry-bucket.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
        }
      }
    }]
  })
}

# Outputs
output "url" {
  value = "http://${aws_cloudfront_distribution.cdn.domain_name}"
}

output "waf_id" {
  value = aws_wafv2_web_acl.cloudfront_waf.id
}