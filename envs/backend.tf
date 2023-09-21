terraform {
  backend "s3" {
    bucket         = "sushi-order-system-state"
    region         = "ap-northeast-1"
    key            = "prod.tfstate"
    profile        = "sushi-order-system"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.1"
    }
  }
}