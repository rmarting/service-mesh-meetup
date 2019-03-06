#!/bin/bash

# Environment
. ./0-environment.sh

oc new-project ${MSA_PROJECT_NAME}

oc adm policy add-scc-to-user privileged -z default -n ${MSA_PROJECT_NAME}

GIT_URI="https://github.com/rmarting/service-mesh-meetup"
GIT_REF="master"
COOLSTORE_GW_ENDPOINT="http://$(oc get route istio-ingressgateway -n ${ISTIO_SYSTEM_NAMESPACE} | awk 'NR>1 {print $2}')"

oc process -p GIT_URI=${GIT_URI} -p GIT_REF=${GIT_REF} -p COOLSTORE_GW_ENDPOINT=${COOLSTORE_GW_ENDPOINT} -f ../microservices/coolstore-msa-template.yaml | \
  oc apply -n ${MSA_PROJECT_NAME} -f -
