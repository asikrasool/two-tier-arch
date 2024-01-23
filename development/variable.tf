
variable "ami_id" {
  description = "ami id"
  type        = string
  default     = "ami-087c17d1fe0178315"
}

variable "instance_type" {
  description = "Instance type to create an instance"
  type        = string
  default     = "t2.micro"
}

variable "ssh_private_key" {
  description = "pem file of Keypair we used to login to EC2 instances"
  type        = string
  default     = "../files/id_rsa"
}

variable "env" {
  description = "Declare environment name"
  default     = "development"
}

variable "project_name" {
  description = "Declare project name"
  default     = "cloudbees"
}