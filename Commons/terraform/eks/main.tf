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
    key            = "eks/stardust.tfstate"
  }
}

provider aws {
  region  = "ca-central-1"
}

module "Stardust_eks" {
  source                    = "./modules"
  common_tags               = var.common_tags
  resource_prefix           = var.resource_prefix
  vpc_cidr_block            = var.vpc_cidr_block
  availability_zones_count  = var.availability_zones_count
  cluster_prefix            = var.cluster_prefix
  instance_types            = var.instance_types
  disk_size                 = var.disk_size
}