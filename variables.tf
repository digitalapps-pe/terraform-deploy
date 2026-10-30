variable "aws_region" {
  description = "Región de AWS donde se crea la VPC."
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Valor de la etiqueta Name de la VPC."
  type        = string
  default     = "my-vpc-01"
}

variable "vpc_cidr" {
  description = "Bloque CIDR IPv4 de la VPC. La máscara debe estar entre /16 y /28."
  type        = string
  default     = "10.0.0.0/24"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0)) && tonumber(split("/", var.vpc_cidr)[1]) >= 16 && tonumber(split("/", var.vpc_cidr)[1]) <= 28
    error_message = "El CIDR debe ser válido y con máscara entre /16 y /28 (regla de AWS)."
  }
}
