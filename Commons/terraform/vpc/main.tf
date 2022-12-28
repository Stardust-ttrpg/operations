terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    region         = "ca-central-1"
    bucket         = "ph-terraform-state-files"
    key            = "vpc/stardust.tfstate"
  }
}

provider aws {
  region  = "ca-central-1"
  default_tags {
    tags = var.common_tags
  }
}

module "Stardust_vpc" {
  source                    = "./modules"
  common_tags               = var.common_tags
  resource_prefix           = var.resource_prefix
  vpc_cidr_block            = var.vpc_cidr_block
}