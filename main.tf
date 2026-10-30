###############################################################################
# Infraestructura mínima: solo 1 VPC básica (equivale a "Solo la VPC" en AWS)
###############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Única VPC. Sin subredes, sin gateways, sin NAT: lo mínimo posible.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default" # Tenencia = Predeterminado (hardware compartido)
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = var.vpc_name
    Environment = "lab"
    ManagedBy   = "Terraform"
    Course      = "Ethical Hacking y Seguridad - ESAN"
  }
}
