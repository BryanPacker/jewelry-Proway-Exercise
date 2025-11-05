output "private_ip_Bryan" {
  value = { for k, v in aws_instance.instance_Bryan : k => v.private_ip }
}
output "public_ip_Bryan" {
  value = { for k, v in aws_instance.instance_Bryan : k => v.public_ip }
}
output "private_ip_BryanNpublic" {
  value = { for k, v in aws_instance.instance_BryanNpublic : k => v.private_ip }
}
output "instance_ids_BryanNpublic" {
  value = { for k, v in aws_instance.instance_BryanNpublic : k => v.id }
}
output "instance_ids_Bryan" {
  value = { for k, v in aws_instance.instance_Bryan : k => v.id }
}
output "subnet_id" {
  value = aws_subnet.bryan_subnet.id
}
