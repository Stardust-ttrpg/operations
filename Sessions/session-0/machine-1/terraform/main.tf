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
    key            = "sessions/session-0/test.tfstate"
  }
}

provider aws {
  region  = "ca-central-1"
  default_tags {
    tags = var.common_tags
  }
}

resource "random_string" "unique_id" {
  length  = 5
  special = false
}

module "machine_1" {
  source          = "./modules"
  common_tags     = var.common_tags
  unique_id       = random_string.unique_id.result
  resource_prefix = var.resource_prefix
  vpc_cidr_block  = var.vpc_cidr_block
  instance_type   = var.instance_type
  volume_size     = var.volume_size
  subnet_id       = var.subnet_id
}
