#
# Conjur Provider for Terraform
#

terraform {
  required_providers {
    conjur = {
      source = "cyberark/conjur"
      version = "0.6.3"
    }
  }
}

variable "conjur_host_id" {
  type = string
}

variable "conjur_api_key" {
  type = string
  sensitive = true
}

variable "conjur_cloud_url" {
  type = string
}

provider "conjur" {
  appliance_url = var.conjur_cloud_url
  account = "conjur"
  login = var.conjur_host_id
  api_key = var.conjur_api_key
}