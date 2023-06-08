terraform {
  cloud {
    organization = "quincycheng"

    workspaces {
      name = "conjur_cloud_demo"
    }
  }

  required_version = ">= 1.1.2"
}
