#!/bin/bash

eval $(minishift oc-env)
eval $(minishift docker-env)

oc login $(minishift ip):8443 -u admin -p admin
