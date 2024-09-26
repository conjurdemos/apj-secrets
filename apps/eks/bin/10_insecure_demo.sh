#!/bin/bash

aws eks update-kubeconfig --region us-east-1 --name apjsecrets-eks-shared &&
kubectl config set-context --current --namespace=test-app-namespace

#original
echo "visit http://localhost:30002"
kubectl port-forward svc/insecure 8080:8080 