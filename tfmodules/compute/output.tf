# ------- module/outputs.tf
output "public_ip" {
  value = aws_instance.app_server[*].public_ip
}
output "instance_ids" {
  value = aws_instance.app_server[*].id
}