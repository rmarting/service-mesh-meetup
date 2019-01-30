#!/bin/bash

# Environment
. ./0-environment.sh

# Download istio
curl -L https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-${OS}.tar.gz | tar xz

cd istio-${ISTIO_VERSION}
export ISTIO_HOME=`pwd`
export PATH=$ISTIO_HOME/bin:$PATH

oc apply -f install/kubernetes/helm/istio/templates/crds.yaml
oc apply -f install/kubernetes/istio-demo.yaml

oc project ${ISTIO_PROJECT_NAME}

oc expose svc istio-ingressgateway
oc expose svc servicegraph
oc expose svc grafana
oc expose svc prometheus
oc expose svc tracing
