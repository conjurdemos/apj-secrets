#!/bin/bash
export CONJUR_SSL_CERT=$(openssl s_client -showcerts  -connect apj-secrets.secretsmgr.cyberark.cloud:443  </dev/null 2>/dev/null | sed -n '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' )

kubectl -n test-app-namespace create configmap conjur-ssl-cert --from-literal=ssl-certificate="${CONJUR_SSL_CERT}"
#kubectl -n important-app-namespace create configmap conjur-ssl-cert --from-literal=ssl-certificate="${CONJUR_SSL_CERT}"
#kubectl -n random-app-namespace create configmap conjur-ssl-cert --from-literal=ssl-certificate="${CONJUR_SSL_CERT}"
