#!/bin/bash

# Environment
. ./0-environment.sh

echo "Deploy Kiali Definitions ..."

for yaml in secret configmap serviceaccount clusterrole clusterrolebinding deployment service route ingress crds
do
  curl https://raw.githubusercontent.com/kiali/kiali/${KIALI_VERSION}/deploy/openshift/${yaml}.yaml | envsubst |  oc apply -n ${ISTIO_SYSTEM_NAMESPACE} -f -
done

echo "Deploying Kiali Services. It will take some minutes ..."
sleep 120
