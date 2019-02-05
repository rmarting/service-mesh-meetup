#!/bin/bash

# Environment
. ./0-environment.sh

oc delete project ${ISTIO_SYSTEM_NAMESPACE}
oc delete project ${ISTIO_OPERATOR_NAMESPACE}
oc delete csr istio-sidecar-injector.istio-system
oc get crd  | grep istio | awk '{print $1}' | xargs oc delete crd
oc get mutatingwebhookconfigurations  | grep istio | awk '{print $1}' | xargs oc delete mutatingwebhookconfigurations
oc get validatingwebhookconfiguration  | grep istio | awk '{print $1}' | xargs oc delete validatingwebhookconfiguration
oc get clusterroles  | grep istio | awk '{print $1}' | xargs oc delete clusterroles
oc get clusterrolebindings  | grep istio | awk '{print $1}' | xargs oc delete clusterrolebindings
