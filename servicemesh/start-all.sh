#!/bin/bash

echo ">>>> 1 setting up minishft <<<<"
sh 1-setup-minishift.sh
echo ">>>> 1 minishft console: http://`minishift ip`:8443 <<<<"

echo ">>>> 2 logging in to minishft <<<<"
sh 2-login-minishift.sh
echo ">>>> 2 loged as: `oc whoami` <<<<"

echo ">>>> 3 installing istio <<<<"
sh 3-install-istio.sh

echo ">>>> 4 installing kiali <<<<"
sh 4b-install-kiali.sh

echo ">>>> 5 deploying MSA <<<<"
sh 5-deploy-msa.sh

echo ">>>> 6 gateway, destination rules, ... <<<<"
sh 6-gateway.sh

# open web console
minishift console