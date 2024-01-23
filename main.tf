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
}

terraform {
  backend "s3" {
    bucket = "asikcloudbees"
    key    = "task1/vpc/terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "task1-tf-table"
    encrypt = true
  }
}