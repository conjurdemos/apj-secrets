#!/bin/bash

# Set Conjur Cloud CLI for various OS
case "$(uname -s)" in
    Linux*)
        ccc='conjur'
        ;;
    Darwin*)    
        ccc='/Applications/ConjurCloudCLI.app/Contents/Resources/conjur/conjur'
        ;;
    *)
        echo "Not Supported OS: ${unameOut}"
        exit 1
        ;;
esac

# Init & Login
#${ccc} init --force -u https://apj-secrets.secretsmgr.cyberark.cloud/api
#${ccc} login

###############################
#  Authn-JWT for Jenkins 
#  https://jenkins.pov.quincycheng.com
${ccc} policy load -f ./conjur/authn-jwt/authn-jwt-jenkins.yml -b conjur/authn-jwt

${ccc} variable set -i conjur/authn-jwt/jenkins/jwks-uri -v https://jenkins.pov.quincycheng.com/jwtauth/conjur-jwk-set
${ccc} variable set -i conjur/authn-jwt/jenkins/token-app-property -v identity
${ccc} variable set -i conjur/authn-jwt/jenkins/identity-path -v data/jenkins-apps
${ccc} variable set -i conjur/authn-jwt/jenkins/audience -v apj-secrets
${ccc} variable set -i conjur/authn-jwt/jenkins/issuer -v https://jenkins.pov.quincycheng.com

${ccc} authenticator enable --id authn-jwt/jenkins
${ccc} policy load -f ./data/apps-jenkins.yml -b data
${ccc} policy load -f ./conjur/authn-jwt/jenkins/grant-jenkins.yml -b conjur/authn-jwt/jenkins
${ccc} policy load -f ./data/entitle-jenkins.yml -b data

###############################
#  Authn-iam for apj-secrets 
#  
${ccc} policy load -f ./conjur/authn-iam/authn-iam-apj_secrets.yml -b conjur/authn-iam
${ccc} authenticator enable --id authn-iam/apj_secrets
${ccc} policy load -f ./data/apps-aws.yml -b data
${ccc} policy load -f ./conjur/authn-iam/apj_secrets/grant_apj_secrets.yml -b conjur/authn-iam/apj_secrets
${ccc} policy load -f ./data/entitle-aws.yml -b data


###############################
#  Authn-azure for apj-secrets 
#  
${ccc} policy load -f ./conjur/authn-azure/authn-azure-apj_secrets.yml -b conjur/authn-azure
${ccc} variable set -i conjur/authn-azure/apj_secrets/provider-uri -v https://sts.windows.net/dc5c35ed-5102-4908-9a31-244d3e0134c6/
${ccc} authenticator enable --id authn-azure/apj_secrets
${ccc} policy load -f ./data/apps-azure.yml -b data
${ccc} policy load -f ./conjur/authn-azure/apj_secrets/grant_apj_secrets.yml -b conjur/authn-azure/apj_secrets
${ccc} policy load -f ./data/entitle-azure.yml -b data


############################
#  Authn-JWT for kubernetes
# 
${ccc} policy load -f ./conjur/authn-jwt/authn-jwt-kubernetes.yaml -b conjur/authn-jwt

${ccc} variable set -i conjur/authn-jwt/dev-cluster/public-keys -v "{\"type\":\"jwks\", \"value\":$(cat ./conjur/authn-jwt/kubernetes/jwks.json)}"
${ccc} variable set -i conjur/authn-jwt/dev-cluster/issuer -v https://kubernetes.default.svc.cluster.local
${ccc} variable set -i conjur/authn-jwt/dev-cluster/token-app-property -v "sub"
${ccc} variable set -i conjur/authn-jwt/dev-cluster/identity-path -v data/apj_secrets/kubernetes-apps
${ccc} variable set -i conjur/authn-jwt/dev-cluster/audience -v "https://kubernetes.default.svc.cluster.local"

${ccc} authenticator enable --id authn-jwt/dev-cluster

${ccc} policy load -f ./data/apps-kubernetes.yml -b data

${ccc} policy load -f ./conjur/authn-jwt/kubernetes/grant-kubernetes.yml -b conjur/authn-jwt/dev-cluster
${ccc} policy load -f ./data/entitle-kubernetes.yml -b data

