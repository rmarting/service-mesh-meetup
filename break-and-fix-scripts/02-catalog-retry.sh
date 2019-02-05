#!/bin/bash

# Environment
. ../servicemesh/0-environment.sh

# Cleaning resources
oc delete destinationrule -n ${MSA_PROJECT_NAME} catalog
oc delete virtualservice -n ${MSA_PROJECT_NAME} catalog-retry

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: catalog
spec:
  host: catalog
  subsets:
  - labels:
      version: 1.0.0
    name: version-v1
EOF

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: catalog-retry
spec:
  hosts:
  - catalog
  http:
  - retries:
      attempts: 3
      perTryTimeout: 5.000s
    route:
    - destination:
        host: catalog
        subset: version-v1
      weight: 100
EOF

