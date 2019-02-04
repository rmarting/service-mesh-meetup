#!/bin/bash

# Environment
. ./0-environment.sh

## Installs Kiali's configmap
#curl https://raw.githubusercontent.com/kiali/kiali/${KIALI_VERSION}/deploy/openshift/kiali-configmap.yaml | \
#  VERSION_LABEL=${KIALI_VERSION} \
#  JAEGER_URL=${JAEGER_URL}  \
#  GRAFANA_URL=${GRAFANA_URL} envsubst | oc create -n istio-system -f -

## Installs Kiali's secrets
#curl https://raw.githubusercontent.com/kiali/kiali/${KIALI_VERSION}/deploy/openshift/kiali-secrets.yaml | \
#  VERSION_LABEL=${KIALI_VERSION} envsubst | oc create -n istio-system -f -

## Deploys Kiali to the cluster
#curl https://raw.githubusercontent.com/kiali/kiali/${KIALI_VERSION}/deploy/openshift/kiali.yaml | \
#  VERSION_LABEL=${KIALI_VERSION}  \
#  IMAGE_NAME=kiali/kiali \
#  IMAGE_VERSION=${KIALI_VERSION}  \
#  NAMESPACE=istio-system  \
#  VERBOSE_MODE=4  \
#  IMAGE_PULL_POLICY_TOKEN="imagePullPolicy: Always" envsubst | oc create -n istio-system -f -

echo "Deploy Kiali Definitions ..."

for yaml in secret configmap serviceaccount clusterrole clusterrolebinding deployment service route ingress crds
do
  curl https://raw.githubusercontent.com/kiali/kiali/${KIALI_VERSION}/deploy/openshift/${yaml}.yaml | envsubst |  oc apply -n ${ISTIO_SYSTEM_NAMESPACE} -f -
done

echo "Deploying Kiali Services. It will take some minutes ..."
sleep 120
