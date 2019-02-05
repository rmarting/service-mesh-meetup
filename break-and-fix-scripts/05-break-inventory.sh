#!/bin/sh

# Breaking - Inventory Service
# Breaking - Inventory - Exception
# http://inventory-coolstore.$(minishift ip).nip.io/api/break/exception/Opps.%20Something%20was%20wrong

# OCP Environment
OCP_BASE_URL=${1:-"coolstore.$(minishift ip).nip.io"}
EXCEPTION_MSG=${3:-"Opps.%20Please,%20Redeploy%20me!!!"}

# Service and Break Type
SERVICE="inventory"
BREAK_TYPE="exception/$EXCEPTION_MSG"

# Generating Break Url
OCP_BREAK_URL="http://$SERVICE-$OCP_BASE_URL/api/break/$BREAK_TYPE"

echo "Breaking '$SERVICE' with '$BREAK_TYPE'"
echo "OCP Break Url: $OCP_BREAK_URL"

# Invoking service
HTTP_RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}\n" $OCP_BREAK_URL)
# extract the body
HTTP_BODY=$(echo $HTTP_RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')
# extract the status
HTTP_STATUS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

if [[ $HTTP_STATUS = "200" ]] ; then
  echo "$HTTP_BODY"
else
  echo "Something was wrong to break the service ($HTTP_STATUS). Review deployment"
  # oc rollout latest "dc/$service"
fi
