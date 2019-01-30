#!/bin/bash

eval $(minishift oc-env)
eval $(minishift docker-env)

oc login $(minishift ip):8443 -u admin -p admin

# Secret with credentials to pull images from registry.redhat.io
oc create secret docker-registry imagestreamsecret --docker-username=${MINISHIFT_USERNAME} --docker-password=${MINISHIFT_PASSWORD} --docker-server=registry.redhat.io -n openshift --as system:admin

# Update images streams from registry.redhat.io
oc delete is --all -n openshift
oc apply -n openshift -f https://raw.githubusercontent.com/openshift/origin/master/examples/image-streams/image-streams-rhel7.json
