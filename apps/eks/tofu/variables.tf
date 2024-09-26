variable "prefix" {
  type        = string
  default = "apjsecrets"
  description = "The prefix string of the resources.  please use your name (lowercase, no space) as prefix"
}

locals {
  description = "Default user role"
  my_role_arn = "arn:aws:iam::409556437035:role/CyberArk-Identity"
}

variable "kubernetes_version" {
  default     = "1.30"
  description = "kubernetes version"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}
variable "aws_region" {
  default     = "us-east-1"
  description = "aws region"
}

