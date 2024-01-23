
module "vpc" {
  source = "../tfmodules/vpc"

  env             = "cloudbees-${var.env}"
  project         = var.project_name
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  private_subnet_tags = {
    "terraform"   = "true"
    "project"     = "task1"
    "environment" = "cloudbees-prod"
  }

  public_subnet_tags = {
    "terraform"   = "true"
    "project"     = "task1"
    "environment" = "cloudbees-prod"
  }
}

