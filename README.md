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
    │   ├── eks                    # Demo kubernetes manifests for EKS
    │   ├── gitlab                 # Demo pipeline and terraform files for GitLab
    │   ├── kubernetes             # Demo kubernetes manifests for Kubernetes
    │   ├── openshift              # Demo kubernetes manifests for OpenShift
    │   ├── registratino           # Source code for self-registration portal     
    │   └── terraform_cloud        # Demo manifests for Terraform Cloud 
    └── policy                     # Conjur Policies
        ├── conjur                 # Policies under /conjur, mainly for Conjur Authenticators
        ├── data                   # Policies under /data, mainly for app identities and entitlements
        └── conjur_load_policy.sh  # Script for loading policies to Conjur Cloud using CLI
    
# Demo Instructions
## OpenShift
1. Create `test-app-namespace`
2. Create `configmap` `conjur-ssl-cert`, with key `ssl-certificate` and value of Conjur Cloud cert (e.g. `apps/openshift/apj-secrets.crt`)
3. Update `conjur/authn-jwt/openshift/jwks.json` with OpenShift JWKS public key
4. Review and create `authn-jwt/openshift` (line 222-238).  Update the files accordingly if needed
5. Deploy manifests in `apps/openshift` folders
6. Access OpenShift Console, access the routes under `test-app-namespace` project
   
## Maintainer
Quincy Cheng
