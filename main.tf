module "ec2_instance" {
  source = "./modules/ec2"
  instance_type = var.instance_type
  aws_region    = var.aws_region
}

module "remote_backend" {
  source = "./modules/remote_backend"
  aws_region        = var.aws_region
  state_bucket_name = var.state_bucket_name
  lock_table_name   = var.lock_table_name
}

output "public_ip_Bryan" {
  value = { for k, v in aws_instance.jewerly_instance_bryan : k => v.public_ip }
}