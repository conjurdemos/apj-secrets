# Optional Input variable
variable "region" {
  default = "us-east-1"
}

# Read .env
locals {
  envs = { for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => tuple[1] }
}

# Providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.14.0"
    }
    conjur = {
      source  = "cyberark/conjur"
      version = "0.6.3"
    }
  }
}

# Config Conjur Provider
provider "conjur" {
  appliance_url = local.envs["CONJUR_APPLIANCE_URL"]
  account       = local.envs["CONJUR_ACCOUNT"]
  login         = local.envs["CONJUR_AUTHN_LOGIN"]
  api_key       = local.envs["CONJUR_AUTHN_API_KEY"]
}

# Retrieve the ephemeral AWS Federation Token
data "conjur_secret" "demo_aws_ephemeral_secret" {
  name = "data/ephemerals/demo-aws-ephemeral-secret"
}

# Parse the response from Conjur for AWS
locals {
  parsed_result = jsondecode(data.conjur_secret.demo_aws_ephemeral_secret.value)
}

# Establish a session with AWS
provider "aws" {
  region     = var.region
  access_key = local.parsed_result.data.access_key_id
  secret_key = local.parsed_result.data.secret_access_key
  token      = local.parsed_result.data.session_token
}

# Use the AWS ephemeral secrets to list all running EC2 instances
data "aws_instances" "aws_running_instances" {
  instance_state_names = ["running"]
}

# Get First EC2 instance
data "aws_instance" "aws_running_instance" {
  instance_id = data.aws_instances.aws_running_instances.ids[0]
}

# Print ARN of the 1st EC2 instance
output "ec2_on_1st_aws_account" {
  value = data.aws_instance.aws_running_instance.arn
}

# KMS on another account
data "aws_kms_key" "by_key_arn" {
  key_id = "arn:aws:kms:us-east-1:600557127681:alias/demo_key"
}

# Print ARN of KMS
output "kms_on_2nd_aws_account" {
  value = data.aws_kms_key.by_key_arn.arn
}