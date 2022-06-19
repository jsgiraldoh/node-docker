terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.19.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "2.2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Org       = "UNIR"
      ManagedBy = "Terraform"
    }
  }
}

provider "http" {}
