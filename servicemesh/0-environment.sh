#!/bin/bash

# Minishift
export MINISHIFT_PROFILE="coolstore"
export MINISHIFT_MEMORY="10GB"
export MINISHIFT_CPUS="2"
export MINISHIFT_VM_DRIVER="xhyve" # xhyve | virtualbox | kvm
export MINISHIFT_DISK_SIZE="40g"

# Istio
export ISTIO_VERSION=1.0.5
export ISTIO_PROJECT_NAME="istio-system"
export OS="osx" # osx | linux

# Kiali
export KIALI_VERSION="v0.10.0"

# Kiali - URLS for Jaeger and Grafana
export JAEGER_URL="https://jaeger-query-${ISTIO_PROJECT_NAME}.$(minishift ip).nip.io"
export GRAFANA_URL="https://grafana-${ISTIO_PROJECT_NAME}.$(minishift ip).nip.io"

# Microservices
export INGRESS_URL="http://istio-ingressgateway-${ISTIO_PROJECT_NAME}.$(minishift ip).nip.io"
#export SECURE_INGRESS_URL="https://istio-ingressgateway-${ISTIO_PROJECT_NAME}.$(minishift ip).nip.io"
export MSA_PROJECT_NAME=coolstore
export GIT_REF="istio-1.0.5"
