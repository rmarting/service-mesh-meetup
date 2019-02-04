#!/bin/bash

# Environment
. ../0-environment.sh

# Cleaning resources
oc delete destinationrule -n ${MSA_PROJECT_NAME} inventory-cb

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: inventory-cb
spec:
  host: inventory
  subsets:
  - labels:
      version: 1.0.0
    name: version-v1
    trafficPolicy:
      connectionPool:
        http: {}
        tcp: {}
      loadBalancer:
        simple: RANDOM
      outlierDetection:
        baseEjectionTime: 120.000s
        consecutiveErrors: 1
        interval: 30.000s
        maxEjectionPercent: 100
EOF
