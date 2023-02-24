# APJ-Secrets

## Overview

This repo stores the demo/POV info on Conjur Cloud & Secrets Hub
Please refer to APJ Secrets SharePoint page for more details

## Content
    .
    ├── apps
    │   ├── azure                  # Script for authn-azure demo
    │   ├── container              # Source code for container images
    │   ├── demoapp                # Demo application with Identity, Conjur Cloud & Secrets Hub
    │   └── kubernetes             # Kubernetes Deployments
    └── policy                     # Conjur Policies
        ├── conjur                 # Policies under /conjur, mainly for Conjur Authenticators
        ├── data                   # Policies under /data, mainly for app identities and entitlements
        └── conjur_load_policy.sh  # Script for loading policies to Conjur Cloud using CLI
    

## Maintainer
Quincy Cheng
