#!/bin/bash

# Minishift
export MINISHIFT_PROFILE="servicemesh"
export MINISHIFT_MEMORY="12GB"
export MINISHIFT_CPUS="2"
export MINISHIFT_VM_DRIVER="kvm" # xhyve | virtualbox | kvm
export MINISHIFT_DISK_SIZE="40g"

# Maistra
export MAISTRA_VERSION=0.6.0
export MAISTRA_TYPE=product # community | product

# Istio
export ISTIO_VERSION=1.0.5
export ISTIO_OPERATOR_NAMESPACE="istio-operator"
export ISTIO_SYSTEM_NAMESPACE="istio-system"
export OS="linux" # osx | linux

# Kiali
export KIALI_VERSION=v0.14.0
export SUBDOMAIN="$(minishift ip).nip.io"
export NAMESPACE=istio-system
export ISTIO_NAMESPACE=istio-system
export IMAGE_NAME="${IMAGE_NAME:-kiali/kiali}"
export IMAGE_VERSION="${IMAGE_VERSION:-$KIALI_VERSION}"
export VERSION_LABEL="${VERSION_LABEL:-$IMAGE_VERSION}"
export IMAGE_PULL_POLICY_TOKEN="${IMAGE_PULL_POLICY_TOKEN:-imagePullPolicy: Always}"
export JAEGER_URL="${JAEGER_URL:-https://jaeger-query-istio-system.$SUBDOMAIN}"
export GRAFANA_URL="${GRAFANA_URL:-http://grafana-istio-system.$SUBDOMAIN}"
export VERBOSE_MODE="${VERBOSE_MODE:-3}"
export KIALI_USERNAME_BASE64
export KIALI_PASSPHRASE_BASE64

# Microservices
export MSA_PROJECT_NAME="coolstore"
