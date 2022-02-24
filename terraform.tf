terraform {
  required_version = "1.1.6"
  backend "s3" {
    bucket = "your-tfstate-bucket-name"
    key    = "us-east-1/dev/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
