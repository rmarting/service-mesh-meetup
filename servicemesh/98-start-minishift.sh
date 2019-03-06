#!/bin/bash

# Environment
. ./0-environment.sh

minishift start 

# Elastic search requirement
minishift ssh sudo sysctl vm.max_map_count=262144
