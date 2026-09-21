#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get configmap app-config -n athena -o jsonpath='{.data.MAX_CONNECTIONS}' 2>/dev/null)
if [ "$v" = "100" ]; then echo "Success: MAX_CONNECTIONS=100"; exit 0; else echo "Error: MAX_CONNECTIONS is '$v', expected 100"; exit 1; fi
