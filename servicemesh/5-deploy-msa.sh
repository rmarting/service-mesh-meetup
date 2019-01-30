#!/bin/bash

# Environment
. ./0-environment.sh

oc new-project ${MSA_PROJECT_NAME}

oc adm policy add-scc-to-user privileged -z default -n ${MSA_PROJECT_NAME}

oc process -f ../microservices/coolstore-msa-template.yaml | \
 istio-${ISTIO_VERSION}/bin/istioctl kube-inject -f - | \
 oc apply -n ${MSA_PROJECT_NAME} -f -
