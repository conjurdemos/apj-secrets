#!/bin/bash
aws eks update-kubeconfig --region us-east-1 --name apjsecrets-eks-shared &&
kubectl config set-context --current --namespace=test-app-namespace

echo "visit http://localhost:30002"
kubectl port-forward svc/sidecar-app-service 30002::30002