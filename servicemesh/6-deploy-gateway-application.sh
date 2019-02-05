#!/bin/bash

# Environment
. ./0-environment.sh

echo "Cleaning Istio Resources ..."

# Cleaning resources
oc delete virtualservice ${MSA_PROJECT_NAME}-api -n ${MSA_PROJECT_NAME}
oc delete virtualservice ${MSA_PROJECT_NAME}-web -n ${MSA_PROJECT_NAME}
oc delete virtualservice ${MSA_PROJECT_NAME}-inventory -n ${MSA_PROJECT_NAME}
oc delete gateway ${MSA_PROJECT_NAME}-gateway -n ${MSA_PROJECT_NAME}

echo "Creating Ingress Gateway and Virtual Services ..."

# Create a gateway
cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ${MSA_PROJECT_NAME}-gateway
spec:
  selector:
    istio: ingressgateway # use istio default controller
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
  name: ${MSA_PROJECT_NAME}-api
spec:
  hosts:
  - "*"
  gateways:
  - ${MSA_PROJECT_NAME}-gateway
  http:
  - match:
    - uri:
        exact: /api/products
    route:
    - destination:
        host: gateway
        port:
          number: 8080
EOF

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: ${MSA_PROJECT_NAME}-web
spec:
  hosts:
  - "*"
  gateways:
  - ${MSA_PROJECT_NAME}-gateway
  http:
  - match:
    - uri:
        prefix: /
    route:
    - destination:
        host: web-ui
        port:
          number: 8080
EOF

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: ${MSA_PROJECT_NAME}-inventory
spec:
  hosts:
  - "*"
  gateways:
  - ${MSA_PROJECT_NAME}-gateway
  http:
  - match:
    - uri:
        prefix: /api/inventory
    route:
    - destination:
        host: inventory
        port:
          number: 8080
EOF
