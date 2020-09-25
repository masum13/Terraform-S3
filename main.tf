terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = var.region
}

module "s3" {
  source        = "app.terraform.io/masum-practice/s3/aws"
  version       = "1.0.0"
  bucket_name   = var.name
  region        = var.region
  bucket_prefix = var.prefix
}
