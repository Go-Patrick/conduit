terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = "ap-southeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "demo1"
}

terraform {
  backend "s3" {
    bucket = "demo1-state-bucket"
    key    = "project3/global/state/terraform.tfstate"
    region = "ap-southeast-1"
  }
}