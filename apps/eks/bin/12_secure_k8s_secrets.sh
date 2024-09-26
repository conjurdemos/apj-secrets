#!/bin/bash
aws eks update-kubeconfig --region us-east-1 --name apjsecrets-eks-shared &&
kubectl config set-context --current --namespace=test-app-namespace

echo "visit http://localhost:30003"
kubectl port-forward svc/k8ssecret-app-service 30003::30003