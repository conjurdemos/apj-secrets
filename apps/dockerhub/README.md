# Managing imagePullSecrets of Kubernetes

The repo contains the step to deliver imagePullSecrets to Kubernetes from CyberArk PAM via Conjur using authn-jwt by secrets provider for kubenetes

We will use a private repo on Docker Hub, Conjur Cloud & Kubernetes as an example

## Steps

1. [PAM] Create a credential in PAM for imagePullSecrets
   
   The value should be something like:
   ```
   {"auths":{"docker.io":{"username":"quincychengdemo","password":"<docker hub password>","email":"quincy.cheng@cyberark.com","auth":"<base64 string of username:password>"}}} 
   ```
   Please refer to https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ for details
   
2. [Conjur] Sync safe & accounts from Privilege Cloud
   
   https://docs.cyberark.com/conjur-cloud/latest/en/Content/ConjurCloud/cl_addaccount.htm

3. [Conjur] Setup workload identity for kubernetes on Conjur
   
   https://docs.cyberark.com/conjur-cloud/latest/en/Content/Integrations/k8s-ocp/k8s-app-identity-jwt.htm

4. [Conjur] Setup Authenticate Kubernetes resources
   
   https://docs.cyberark.com/conjur-cloud/latest/en/Content/Integrations/k8s-ocp/k8s-jwt-authn.htm

5. [Kubernetes] Create the imagePullSecrets with dummy credential value
   This is the imagePullSecrets to access the private repo.   The credential value will be replaced at step 7 so dummy(wrong) value is fine.    
   Please refer to https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ for details
   
   For example:
   ```
   kubectl create secret docker-registry regcred -n important-app-namespace --docker-server=docker.io --docker-username=quincychengdemo --docker-password=SuperSecurePassword --docker-email=quincy.cheng@cyberark.com
   ```
   
   For demo or testing purpose, you can deploy an app with image from private repo now, and expected a failure result.
   Sample can be found at step 9.

6. [Kubernetes] Update imagePullSecrets with `conjur-map`
    
    Sample yaml:  [apps/dockerhub/pull-secrets.yaml](https://github.com/conjurdemos/apj-secrets/blob/master/apps/dockerhub/pull-secrets.yaml)

7. [Kubernetes] Setup Kubernetes Cronjob to sync image pull secrets 
   
   Sample yaml:  [apps/dockerhub/k8s-secrets-cronjob.yaml](https://github.com/conjurdemos/apj-secrets/blob/master/apps/dockerhub/k8s-secrets-cronjob.yaml)

8. [Kubernetes] Trigger the cronjob and wait for a new job
   
   Review the log of the generated log to verify

9. [Kubernetes] Deploy application using the imagePullSecrets to access private repo 

   Sample yaml: [apps/dockerhub/deployment.yaml](https://github.com/conjurdemos/apj-secrets/blob/master/apps/dockerhub/deployment.yaml)

   Review the application's pod log to verify

## Reference
- Pull an Image from a Private Registry
  https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/

- CyberArk Conjur Kubernetes Secrets Provider as a CronJob
  https://gist.github.com/infamousjoeg/15e8c445982d1dab4e2b6fd719414bdd

- CyberArk Offiical Doc
  https://docs.cyberark.com