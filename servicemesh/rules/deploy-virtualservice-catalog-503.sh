#!/bin/bash

# Environment
. ../0-environment.sh

# Cleaning resources
oc delete virtualservice -n ${MSA_PROJECT_NAME} catalog-503

cat <<EOF | oc apply -n ${MSA_PROJECT_NAME} -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: catalog-503
spec:
  hosts:
  - catalog
  http:
  - fault:
      abort:
        httpStatus: 503
        percent: 25
      delay:
        fixedDelay: 5.000s
        percent: 25
    route:
    - destination:
        host: catalog
        subset: catalog
EOF
