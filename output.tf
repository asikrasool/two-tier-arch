output "pub_ips" {
  value = module.compute.public_ip
}
output "instance_ids" {
  value = module.compute.instance_ids
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
output "alb_dns" {
  value = aws_lb.my_app_eg1.dns_name
}