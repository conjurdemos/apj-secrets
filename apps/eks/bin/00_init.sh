#!/bin/bash

cd tofu
tofu init && tofu apply

aws eks update-kubeconfig --region us-east-1 --name apjsecrets-eks-shared &&
kubectl config set-context --current --namespace=test-app-namespace


export CONJUR_SSL_CERT=$(openssl s_client -showcerts  -connect apj-secrets.secretsmgr.cyberark.cloud:443  </dev/null 2>/dev/null | sed -n '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' )
kubectl -n test-app-namespace create configmap conjur-ssl-cert --from-literal=ssl-certificate="${CONJUR_SSL_CERT}"
