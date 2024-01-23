variable "ami" {
  description = "ami for our instance"
}
variable "instance_type" {
  description = "the instance type for our instance"
}
# variable "vpc_id" {
#   description = "Environment name."
#   type        = string
# }
variable "subnet_id" {
  description = "Environment name."
  type        = list
}
variable "sg" {
  description = "security group that allows public access via http/ssh"
}
variable "user_data" {
  description = "userdata that will install webserver bashscript"
}
variable "public_access" {
  description = "Associate Public IP to instance."
  type        = bool
}
variable "pub_key" {
  description = "Environment SSH Public to access the EC2 Server."
  type        = string
}
variable "ssh_key_name" {
  description = "SSH key name to created with above public key"
  type        = string
}
variable "project" {
  description = "Project name."
  type        = string
}
variable "env" {
  description = "Environment name."
  type        = string
}
