# CI/CD Pipeline with Security Checks and Terraform Deployment

This repository implements a complete **CI/CD pipeline** that automatically scans your code for security issues and deploys infrastructure to AWS using Terraform.

## 🚀 Quick Overview

The pipeline has **3 workflows**:

1. **Security Checks (CI)** - Runs on every push
   - Checkov (Infrastructure as Code scanning)
   - Trivy (Vulnerability scanning)
   - Semgrep (Code analysis)
   - Gitleaks (Secret detection)

2. **Deploy (CD)** - Triggers automatically after CI passes
   - Validates Terraform
   - Plans infrastructure changes
   - Deploys to AWS

3. **Destroy** - Manual trigger
   - Removes all AWS resources
   - Cleans up Terraform state
