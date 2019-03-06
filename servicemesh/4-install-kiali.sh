#!/bin/bash

# Environment
. ./0-environment.sh

echo "Deploy Kiali Definitions ..."

export JAEGER_URL="$(oc get route jaeger-query -n ${ISTIO_SYSTEM_NAMESPACE} | awk 'NR>1 {printf ($5 == "edge") ? "https://%s" : "http://%s",$2 }')"
export GRAFANA_URL="$(oc get route grafana -n ${ISTIO_SYSTEM_NAMESPACE} | awk 'NR>1 {printf ($5 == "edge") ? "https://%s" : "http://%s",$2 }')" 

for yaml in secret configmap serviceaccount clusterrole clusterrolebinding deployment service route ingress crds
do
  curl https://raw.githubusercontent.com/kiali/kiali/${KIALI_VERSION}/deploy/openshift/${yaml}.yaml | envsubst |  oc apply -n ${ISTIO_SYSTEM_NAMESPACE} -f -
done

echo "Deploying Kiali Services. It will take some minutes ..."
sleep 120
