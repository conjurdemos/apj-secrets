# Demo Kubernetes application in Private Repo on DockerHub 

## Steps

### Create Pull Secrets
kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-username> --docker-password=<your-password> --docker-email=<your-email>

For example:
kubectl create secret docker-registry regcred -n test-app-namespace --docker-server="https://index.docker.io/v1" --docker-username=quincychengdemo --docker-password=SuperSecurePassword --docker-email=quincy.cheng+demo@cyberark.com

### Deploy Demo Deploymennt

Expectation: failed to get image as the "docker-password" above is invalid

k apply -f deployment.yaml

Result
Error: ErrImagePull

Failed to pull image "quincychengdemo/private:v0.1": rpc error: code = Unknown desc = failed to pull and unpack image "docker.io/quincychengdemo/private:v0.1": failed to resolve reference "docker.io/quincychengdemo/private:v0.1": pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed


### Deploy Secrets Provider Cronjob 

k apply -f k8s-secrets-cronjob.yaml



## Reference
Pull an Image from a Private Registry
https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/

CyberArk Conjur Kubernetes Secrets Provider as a CronJob
https://gist.github.com/infamousjoeg/15e8c445982d1dab4e2b6fd719414bdd

Kubernetes “x509: certificate has expired or is not yet valid” error
https://medium.com/@guilospanck/kubernetes-x509-certificate-has-expired-or-is-not-yet-valid-error-cb9ca581d38b
