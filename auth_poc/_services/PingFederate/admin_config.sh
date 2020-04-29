#!/bin/bash
set -e

function uploadConfig {
  if [ -z "$3" ]; then
    action="PUT";
  else
    action="$3";
  fi
  echo "$action $2 $1"
  curl -kX "$action" \
    -fsS --output /dev/null \
    -H "X-XSRF-Header: pingFederate" \
    -H "Content-Type: application/json" \
    -u "${API_USER}:${API_PASS}" \
    -d @"$1" \
    "$2"
  #echo
}

ADMIN_API_URL="https://localhost:9999/pf-admin-api/v1"
ADMIN_UI_URL="https://localhost:9999/pingfederate/app"
DATA_STORE_ID="Custom-5A9685A366E48F35F05EEFA58625BD7AD83A4064"

echo "Applying environment variables to JSON Files..."
# Using "|" separators to avoid issues with slashes in some env vars

sed -i "s|__PING_AUTH_BASEURL__|${PING_AUTH_BASEURL}|" serverSettings.json

sed -i \
  -e "s|__SAPI_URL__|${SAPI_URL}|" \
  -e "s|__LOGGING_URL__|${LOGGING_URL}|" \
  -e "s|__LOGGING_LEVEL__|${LOGGING_LEVEL:-Information}|" \
  practiceSelectAdapterV2.json \
  validateUserAdapter.json \
  customDataStore.json

sed -i "s|__ENV_SERVER__|${ENV_SERVER}|" \
  authServerSettings.json \
  mvc.json \
  polaris.json \
  swagger-ui.json \

sed -i "s|__ENV_DOMAIN__|${ENV_DOMAIN}|" redirectValidation.json

sed -i "s/__MVC_SECRET__/${MVC_SECRET}/" mvc.json

sed -i "s/__INTERGY_SECRET__/${INTERGY_SECRET}/" routing.demo-polaris110.json

sed -i "s/__SSOSERVICE_SECRET__/${SSOSERVICE_SECRET}/" ssoService-oAuthClient.json

if [ -z "$ENABLE_LOCALHOST" ]; then
  sed -i \
    -e 's|__LOCALHOST_UI__||' \
    -e 's|__LOCALHOST_UI_EXTENDED__||' \
    -e 's|__LOCALHOST_SWAGGER__||' \
    -e 's|__LOCALHOST_MS__||' \
    -e 's|__LOCALHOST_REDIRECT__||' \
    authServerSettings.json \
    mvc.json \
    polaris.json \
    redirectValidation.json \
    swagger-ui.json
else
  sed -i 's|__LOCALHOST_UI__|,"http://localhost:4200"|' authServerSettings.json polaris.json
  sed -i 's|__LOCALHOST_UI_EXTENDED__|,"http://localhost:4200","http://localhost:4200/index.html","http://localhost:4200/callback.html"|' polaris.json
  sed -i 's|__LOCALHOST_SWAGGER__|,"http://localhost:1405/swagger/oauth2-redirect.html","http://localhost:15289/swagger/oauth2-redirect.html","http://localhost:22436/swagger/oauth2-redirect.html", "http://localhost:1821/swagger/oauth2-redirect.html"|' swagger-ui.json
  sed -i 's|__LOCALHOST_MS__|,"http://localhost:1405","http://localhost:1405/oauth2-redirect.html","http://localhost:15289","http://localhost:15289/oauth2-redirect.html","http://localhost:22436","http://localhost:22436/oauth2-redirect.html", "http://localhost:1821", "http://localhost:1821/oauth2-redirect.html"|' mvc.json
  sed -i 's|__LOCALHOST_REDIRECT__|,{"validDomain":"localhost","validPath":"","allowQueryAndFragment":true,"requireHttps":false,"targetResourceSLO":true,"targetResourceSSO":false,"inErrorResource":false,"idpDiscovery":false}|' redirectValidation.json
fi

if [ -z "$ENABLE_LOCAL_POLARIS" ]; then
  sed -i \
    -e 's|__LOCAL_POLARIS_UI__||' \
    -e 's|__LOCAL_POLARIS_UI_EXTENDED__||' \
    -e 's|__LOCAL_POLARIS_SWAGGER__||' \
    -e 's|__LOCAL_POLARIS_MS__||' \
    -e 's|__LOCAL_POLARIS_REDIRECT__||' \
    authServerSettings.json \
    mvc.json \
    polaris.json \
    redirectValidation.json \
    swagger-ui.json
else
  sed -i 's|__LOCAL_POLARIS_UI__|,"http://local-polaris.dev1.mdmgr.net"|' authServerSettings.json polaris.json
  sed -i 's|__LOCAL_POLARIS_UI_EXTENDED__|,"http://local-polaris.dev1.mdmgr.net","http://local-polaris.dev1.mdmgr.net/index.html","http://local-polaris.dev1.mdmgr.net/callback.html"|' polaris.json
  sed -i 's|__LOCAL_POLARIS_SWAGGER__|,"http://local-polaris.dev1.mdmgr.net/api/polaris/clinical/swagger/oauth2-redirect.html","http://local-polaris.dev1.mdmgr.net/api/polaris/administration/swagger/oauth2-redirect.html","http://local-polaris.dev1.mdmgr.net/api/polaris/financial/swagger/oauth2-redirect.html","http://local-polaris.dev1.mdmgr.net/api/polaris/catalog-repository/swagger/oauth2-redirect.html"|' swagger-ui.json
  sed -i 's|__LOCAL_POLARIS_MS__|,"http://local-polaris.dev1.mdmgr.net/api/polaris/clinical","http://local-polaris.dev1.mdmgr.net/api/polaris/clinical/oauth2-redirect.html","http://local-polaris.dev1.mdmgr.net/api/polaris/administration","http://local-polaris.dev1.mdmgr.net/api/polaris/administration/oauth2-redirect.html","http://local-polaris.dev1.mdmgr.net/api/polaris/financial","http://local-polaris.dev1.mdmgr.net/api/polaris/financial/oauth2-redirect.html","http://local-polaris.dev1.mdmgr.net/api/polaris/catalog-repository","http://local-polaris.dev1.mdmgr.net/api/polaris/catalog-repository/oauth2-redirect.html"|' mvc.json
  sed -i 's|__LOCAL_POLARIS_REDIRECT__|,{"validDomain":"local-polaris.dev1.mdmgr.net","validPath":"","allowQueryAndFragment":true,"requireHttps":false,"targetResourceSLO":true,"targetResourceSSO":false,"inErrorResource":false,"idpDiscovery":false}|' redirectValidation.json
fi

# Splinlock until service is accepting connections
until curl -X GET -k \
  -H "X-XSRF-Header: pingfederate" \
  -u "${API_USER}:${API_PASS}" \
  --fail \
  --output /dev/null \
  --silent \
  --head \
  "${ADMIN_API_URL}/version"; do
    echo "Waiting on PingFederate to start..."
    sleep 10
done

echo "Local PingFederate Admin Console detected"

## Certs ##
#TODO Need to add calls to upload certs
#uploadConfig ?.json "${ADMIN_API_URL}"/keyPairs/sslServer/import POST
# To set the certs for both endpoints
#uploadConfig ?.json "${ADMIN_API_URL}"/keyPairs/sslServer/settings
# If trusted CA is needed
#uploadConfig ?.json "${ADMIN_API_URL}"/certificates/ca/import POST

echo "Starting configuration via API"

echo "Set License... ${PING_LICENSE}"
curl -kX PUT \
  -fsS -o /dev/null \
  -H "X-XSRF-Header: pingfederate" \
  -H "Content-Type: application/json" \
  -u "${API_USER}:${API_PASS}" \
  -d '{"fileData": "'"${PING_LICENSE}"'"}' \
  "${ADMIN_API_URL}/license"

## Identity Provider ##
echo "Configuring IDP Adapters..."
# IDP Adapters
uploadConfig practiceSelectAdapterV2.json "${ADMIN_API_URL}/idp/adapters" POST
uploadConfig validateUserAdapter.json "${ADMIN_API_URL}/idp/adapters" POST
uploadConfig practiceSelectComposite.json "${ADMIN_API_URL}/idp/adapters" POST

# Session Policies
uploadConfig globalSessionPolicy.json "${ADMIN_API_URL}"/session/authenticationSessionPolicies/global

## Server Configuration ##
echo "Configuring Data Stores..."
# Data Stores
# Trying to create a new data store through the API errors out. Until its fixed we need to PUT to a predefined
# data store. This id must match the pregenerated data store. The same json can be used for PUT and POST.
uploadConfig customDataStore.json "${ADMIN_API_URL}/dataStores/${DATA_STORE_ID}"

# Redirect Validation
uploadConfig redirectValidation.json "${ADMIN_API_URL}/redirectValidation"

echo "Configuring Server Settings..."
# Server Settings
uploadConfig serverSettings.json "${ADMIN_API_URL}/serverSettings"

## OAUTH Server ##
echo "Configuring Auth Server Settings..."
# Auth Server Settings
uploadConfig authServerSettings.json "${ADMIN_API_URL}/oauth/authServerSettings"

# idpAdapter Mappings
uploadConfig idpAdapterMappings.json "${ADMIN_API_URL}/oauth/idpAdapterMappings" POST

# Access Token Managers
uploadConfig accessTokenManager.json "${ADMIN_API_URL}/oauth/accessTokenManagers" POST

# Access Token Mappings
uploadConfig accessTokenMappings.json "${ADMIN_API_URL}/oauth/accessTokenMappings" POST

# OpenID Connection Policy
# TODO DATA_STORE_ID will need to be extracted from the data store POST response when it gets working
sed -i "s/__DATA_STORE_ID__/${DATA_STORE_ID}/" openIDConnectPolicy.json
uploadConfig openIDConnectPolicy.json "${ADMIN_API_URL}/oauth/openIdConnect/policies" POST

echo "Configuring Client Settings..."
# Clients
uploadConfig mvc.json "${ADMIN_API_URL}/oauth/clients" POST
uploadConfig polaris.json "${ADMIN_API_URL}/oauth/clients" POST
uploadConfig routing.demo-polaris110.json "${ADMIN_API_URL}/oauth/clients" POST
uploadConfig swagger-ui.json "${ADMIN_API_URL}/oauth/clients" POST
uploadConfig ssoService-oAuthClient.json "${ADMIN_API_URL}/oauth/clients" POST

# Scopes
uploadConfig ssoService-exclusiveScope.json "${ADMIN_API_URL}/oauth/authServerSettings/scopes/exclusiveScopes" POST

# Change Admin Password
echo "Setting Admin Password..."
curl -kX POST \
  -fsS --output /dev/null \
  -H "X-XSRF-Header: pingFederate" \
  -H "Content-Type: application/json" \
  -u "${API_USER}:${API_PASS}" \
  -d '{"currentPassword":"'"${API_PASS}"'","newPassword":"'"${NEW_PASS}"'"}' \
  "${ADMIN_API_URL}/administrativeAccounts/changePassword"

echo "Triggering replication on Admin Console..."
# Trigger Replicatoin to catch any existing Runtime Engines
# (We assume that existing instances will connect to the cluster by the time we get here)
curl -k -X POST \
  -fsS -o /dev/null \
  -H "X-XSRF-Header: pingfederate" \
  -u "${API_USER}:${NEW_PASS}" \
  "${ADMIN_API_URL}/cluster/replicate"

  echo "Configuration complete"
