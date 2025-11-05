module "ec2_instance" {
  source = "./modules/ec2"
  instance_type = var.instance_type
  aws_region    = var.aws_region
}

module "remote_backend" {
  source = "./modules/remote_backend"
  aws_region        = var.aws_region
  state_bucket_name = var.state_bucket_name
}