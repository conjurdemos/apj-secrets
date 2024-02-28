# APJ-Secrets

## Overview

This repo stores the demo/POV info on Conjur Cloud & Secrets Hub
Please refer to APJ Secrets SharePoint page for more details

## Content
    .
    ├── apps
    │   ├── azure                  # Demo Script for authn-azure 
    │   ├── container              # Source code for container images
    │   ├── cp                     # Demo script for CP
    │   ├── demoapp                # Demo application with Identity, Conjur Cloud & Secrets Hub
    │   ├── dockerhiub             # Demo Kubernetes application in Private Repo on DockerHub 
    │   ├── gitlab                 # Demo pipeline and terraform files for GitLab
    │   ├── kubernetes             # Demo kubernetes manifests for Kubernetes
    │   ├── registratino           # Source code for self-registration portal     
    │   └── terraform_cloud        # Demo manifests for Terraform Cloud 
    └── policy                     # Conjur Policies
        ├── conjur                 # Policies under /conjur, mainly for Conjur Authenticators
        ├── data                   # Policies under /data, mainly for app identities and entitlements
        └── conjur_load_policy.sh  # Script for loading policies to Conjur Cloud using CLI
    

## Maintainer
Quincy Cheng
