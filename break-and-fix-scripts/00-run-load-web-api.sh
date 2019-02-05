#!/bin/bash

# Web UI
# OpenShift Route
#msa_route_web=http://web-ui-coolstore.$(minishift ip).nip.io/
# Ingress Gateway
msa_route_web=http://istio-ingressgateway-istio-system.$(minishift ip).nip.io/
# Gateway
# OpenShift Route
#msa_route_api=http://gateway-coolstore.$(minishift ip).nip.io/api/products
# Ingress Gateway 
msa_route_api=http://istio-ingressgateway-istio-system.$(minishift ip).nip.io/api/products
# Catalog
# OpenShift Route
#msa_route_catalog=http://catalog-coolstore.$(minishift ip).nip.io/api/catalog
# Inventory
# OpenShift Route
#msa_route_inventory=http://inventory-coolstore.$(minishift ip).nip.io/api/inventory/329299
# Ingress Gateway
#msa_route_inventory=http://istio-ingressgateway-istio-system.$(minishift ip).nip.io/api/inventory/329299

while true
do  
  # Invoking service
  HTTP_RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}:SIZE:%{size_download}:TIME:%{time_total}" -H "msa-version: v2" $msa_route_web)
  # extract the body
  HTTP_BODY=$(echo $HTTP_RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')
  # extract the stats
  HTTP_STATS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
  # extract the status
  HTTP_STATUS=$(echo $HTTP_STATS | cut -d ':' -f 1)
  # extract the size
  HTTP_SIZE=$(echo $HTTP_STATS | cut -d ':' -f 3)
  # extract the time
  HTTP_TIME=$(echo $HTTP_STATS | cut -d ':' -f 5)
  
  echo "[WEB] RESPONSE -> CODE: [$HTTP_STATUS] SIZE: [$HTTP_SIZE] TIME: [$HTTP_TIME]"
  
  # Invoking service
  HTTP_RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}:SIZE:%{size_download}:TIME:%{time_total}" -H "msa-version: v2" $msa_route_api)
  # extract the body
  HTTP_BODY=$(echo $HTTP_RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')
  # extract the stats
  HTTP_STATS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
  # extract the status
  HTTP_STATUS=$(echo $HTTP_STATS | cut -d ':' -f 1)
  # extract the size
  HTTP_SIZE=$(echo $HTTP_STATS | cut -d ':' -f 3)
  # extract the time
  HTTP_TIME=$(echo $HTTP_STATS | cut -d ':' -f 5)
  
  echo "[API] RESPONSE -> CODE: [$HTTP_STATUS] SIZE: [$HTTP_SIZE] TIME: [$HTTP_TIME]"

  sleep 2
done
