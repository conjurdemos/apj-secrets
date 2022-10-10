#!/bin/bash

# Get Azure AD Token
aad_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F' -H Metadata:true -s | jq -r '.access_token')

# Get Conjur Access Token
conjur_token=$(curl -s --request POST \
  'https://apj-secrets.secretsmgr.cyberark.cloud/api/authn-azure/apj_secrets/conjur/host%2Fdata%2Fapj_secrets%2Fazure-apps%2FazureVM/authenticate' \
   --header 'Content-Type: application/x-www-form-urlencoded' \
   --header "Accept-Encoding: base64" \
   --data-urlencode "jwt=${aad_token}")

# Get secrets from Conjur
DB_ADDR=$(curl -s -H "Authorization: Token token=\"${conjur_token}\"" \
   https://apj-secrets.secretsmgr.cyberark.cloud/api/secrets/conjur/variable/data/vault/POV/Database-MySQL-database.pov.quincycheng.com-app_service/address)
DB_USER=$(curl -s -H "Authorization: Token token=\"${conjur_token}\"" \
   https://apj-secrets.secretsmgr.cyberark.cloud/api/secrets/conjur/variable/data/vault/POV/Database-MySQL-database.pov.quincycheng.com-app_service/username)
DB_NAME=$(curl -s -H "Authorization: Token token=\"${conjur_token}\"" \
   https://apj-secrets.secretsmgr.cyberark.cloud/api/secrets/conjur/variable/data/vault/POV/Database-MySQL-database.pov.quincycheng.com-app_service/Database)
DB_PASS=$(curl -s -H "Authorization: Token token=\"${conjur_token}\"" \
   https://apj-secrets.secretsmgr.cyberark.cloud/api/secrets/conjur/variable/data/vault/POV/Database-MySQL-database.pov.quincycheng.com-app_service/password)

# Get secrets from Conjur
echo "Address: ${DB_ADDR}"
echo "Database: ${DB_NAME}"
echo "Username: ${DB_USER}"
echo "Password: ${DB_PASS}"

# Execute SQL: SELECT * from `log` ORDER BY time DESC
MYSQL_PWD=${DB_PASS} mysql -h ${DB_ADDR} -u ${DB_USER} ${DB_NAME} -e "SELECT * from log ORDER BY time DESC"