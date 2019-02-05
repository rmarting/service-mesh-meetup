#!/bin/bash

# Environment
. ../servicemesh/0-environment.sh

# Scale up inventory-v2
oc scale --replicas=1 dc inventory-v2 -n ${MSA_PROJECT_NAME} 

# Cleaning resources
oc delete destinationrule -n ${MSA_PROJECT_NAME} inventory
oc delete virtualservice -n ${MSA_PROJECT_NAME} inventory

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: inventory
spec:
  host: inventory
  subsets:
  - name: version-v1
    labels:
      version: 1.0.0
  - name: version-v2
    labels:
      version: 2.0.0
EOF

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: inventory
spec:
  hosts:
    - inventory
  http:
  - route:
    - destination:
        host: inventory
        subset: version-v1
      weight: 60
    - destination:
        host: inventory
        subset: version-v2
      weight: 40
EOF
