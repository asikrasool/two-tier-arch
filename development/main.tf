terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "${var.env}"
      Name        = var.project_name
      Terraform   = "true"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "asikcloudbees"
    key    = "task1/dev/terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "task1-tf-table"
    encrypt = true
  }
}