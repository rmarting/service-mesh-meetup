#!/bin/bash

# Ingress Gateway
ingressgateway_url="$(oc get route istio-ingressgateway -n ${ISTIO_SYSTEM_NAMESPACE} | awk 'NR>1 {printf ($5 == "edge") ? "https://%s" : "http://%s",$2 }')"
msa_route_products=${ingressgateway_url}/api/products

while true
do  
  # Invoking service
  HTTP_RESPONSE=$(curl -H "msa-version: v2" --silent --write-out "HTTPSTATUS:%{http_code}:SIZE:%{size_download}:TIME:%{time_total}" -H "msa-version: v2" $msa_route_products)
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
  
  echo "[INVENTORY] RESPONSE -> CODE: [$HTTP_STATUS] SIZE: [$HTTP_SIZE] TIME: [$HTTP_TIME]"

  sleep 1
done
