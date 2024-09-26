#!/bin/bash


helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm install csi-secrets-store \
  secrets-store-csi-driver/secrets-store-csi-driver \
  --wait \
  --namespace kube-system \
  --set syncSecret.enabled="false" \
  --set 'tokenRequests[0].audience=conjur'

helm repo add cyberark https://cyberark.github.io/helm-charts
helm install conjur-csi-provider \
  cyberark/conjur-k8s-csi-provider \
  --wait \
  --namespace kube-system \
  --set daemonSet.image.tag="0.2.0" \
  --set provider.name="conjur" \
  --set provider.healthPort="8080" \
  --set provider.socketDir="/var/run/secrets-store-csi-providers"


kubectl apply -f 13_1_secretsprovider.yaml -n test-app-namespace
kubectl apply -f 13_2_deployment-with-csi-volume.yml -n test-app-namespace

kubectl exec csi-test-app -- cat /mnt/conjur-csi-volume/conjur/password.txt

# clean up
#kubectl delete -f 13_2_deployment-with-csi-volume.yml -n test-app-namespace
