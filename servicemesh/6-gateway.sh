#!/bin/bash

# Environment
. ./0-environment.sh

# Create a gateway
cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${MSA_PROJECT_NAME}-gateway
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
EOF

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: ${MSA_PROJECT_NAME}
spec:
  hosts:
  - "*"
  gateways:
  - ${MSA_PROJECT_NAME}-gateway
  http:
  - match:
    - uri:
        prefix: /api
    route:
    - destination:
        host: gateway.${MSA_PROJECT_NAME}.svc.cluster.local
        port:
          number: 8080
        subset: 1.0.0-SNAPSHOT
  - route:
    - destination:
        host: web-ui.${MSA_PROJECT_NAME}.svc.cluster.local
        port:
          number: 8080
        subset: 1.0.0-SNAPSHOT
EOF

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: web-ui-destination
spec:
  host: web-ui.${MSA_PROJECT_NAME}.svc.cluster.local
  subsets:
  - name: 1.0.0-SNAPSHOT
    labels:
      version: 1.0.0-SNAPSHOT
EOF

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: gateway-destination
spec:
  host: gateway.${MSA_PROJECT_NAME}.svc.cluster.local
  subsets:
  - name: 1.0.0-SNAPSHOT
    labels:
      version: 1.0.0-SNAPSHOT
EOF