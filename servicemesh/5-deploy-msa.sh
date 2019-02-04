#!/bin/bash

# Environment
. ./0-environment.sh

oc new-project ${MSA_PROJECT_NAME}

oc adm policy add-scc-to-user privileged -z default -n ${MSA_PROJECT_NAME}

cat ../microservices/coolstore-msa-template.yaml | COOLSTORE_GW_ENDPOINT=${INGRESS_URL} envsubst | \
 oc process -f - | \
 istio-${ISTIO_VERSION}/bin/istioctl kube-inject -f - | \
 oc apply -n ${MSA_PROJECT_NAME} -f -