#!/bin/bash

# Environment
. ./0-environment.sh

#
# Installation with Operator (Maistra)
#

echo "Deploying Istio Operator (Maistra) ..."

oc new-project ${ISTIO_OPERATOR_NAMESPACE}

oc new-app -f https://raw.githubusercontent.com/Maistra/openshift-ansible/maistra-${MAISTRA_VERSION}/istio/istio_${MAISTRA_TYPE}_operator_template.yaml \
    --param=OPENSHIFT_ISTIO_MASTER_PUBLIC_URL="https://$(minishift ip):8443"

echo "Waiting some minutes to deploy istio operator pod"
sleep 120

echo "Deploy Istio Definition"
oc create -f ./cr-istio-installation-0-6-0-no-kiali-and-auth.yaml -n ${ISTIO_OPERATOR_NAMESPACE}

echo "Deploying Istio Services. It will take some minutes ..."
sleep 300
