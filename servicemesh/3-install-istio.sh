#!/bin/bash

# Environment
. ./0-environment.sh

#
# Installation without Operator
#

# Download Istio
curl -L https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-${OS}.tar.gz | tar xz

#echo "Deploying Istio from local path ..."
#cd istio-${ISTIO_VERSION}
#export ISTIO_HOME=`pwd`
#export PATH=$ISTIO_HOME/bin:$PATH

#oc apply -f install/kubernetes/helm/istio/templates/crds.yaml
#oc apply -f install/kubernetes/istio-demo.yaml

#oc project ${ISTIO_SYSTEM_NAMESPACE}

#oc expose svc istio-ingressgateway
#oc expose svc servicegraph
#oc expose svc grafana
#oc expose svc prometheus
#oc expose svc tracing

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
# oc create -f ./cr-istio-installation-0-7-0-no-kiali-and-auth.yaml -n ${ISTIO_OPERATOR_NAMESPACE}

echo "Deploying Istio Services. It will take some minutes ..."
sleep 300
