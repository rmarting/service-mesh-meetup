#!/bin/bash

# Environment
. ./0-environment.sh

# add the location of minishift executable to PATH
# I also keep other handy tools like kubectl and kubetail.sh
# in that directory

minishift profile set ${MINISHIFT_PROFILE}
minishift config set memory ${MINISHIFT_MEMORY}
minishift config set cpus ${MINISHIFT_CPUS}
minishift config set vm-driver ${MINISHIFT_VM_DRIVER} ## or virtualbox, or kvm, for Fedora
minishift config set disk-size ${MINISHIFT_DISK_SIZE} # extra disk size for the vm
minishift config set image-caching true
minishift addon enable admin-user
minishift addon enable anyuid
minishift addon disable xpaas

minishift start --skip-startup-checks --skip-registration

minishift ssh -- sudo setenforce 0

eval $(minishift oc-env)
eval $(minishift docker-env)

oc login $(minishift ip):8443 -u admin -p admin

echo "Updating VM and OpenShift Cluster ..."

# Prepare Service Mesh deployment
minishift ssh sudo sysctl vm.max_map_count=262144

sleep 60

minishift openshift config set --target=kube --patch '{
    "admissionConfig": {
         "pluginConfig": {
            "ValidatingAdmissionWebhook": {
                "configuration": {
                    "apiVersion": "apiserver.config.k8s.io/v1alpha1",
                    "kind": "WebhookAdmission",
                    "kubeConfigFile": "/dev/null",
                    "disable": false
                 }
             },
             "MutatingAdmissionWebhook": {
                 "configuration": {
                     "apiVersion": "apiserver.config.k8s.io/v1alpha1",
                     "kind": "WebhookAdmission",
                     "kubeConfigFile": "/dev/null",
                     "disable": false
                  }
              }
         }
    }
}'

echo "Refresing changes in OpenShift Cluster ..."
sleep 60

echo "Deploy Secret to download images from registry.redhat.io registry"

# Secret with credentials to pull images from registry.redhat.io
oc create secret docker-registry imagestreamsecret --docker-username=${MINISHIFT_USERNAME} --docker-password=${MINISHIFT_PASSWORD} --docker-server=registry.redhat.io -n openshift --as system:admin

sleep 10

echo "Reloading base images from registry.redhat.io registry"

# Update images streams from registry.redhat.io
oc delete is --all -n openshift
oc apply -n openshift -f https://raw.githubusercontent.com/openshift/origin/master/examples/image-streams/image-streams-rhel7.json

sleep 10
