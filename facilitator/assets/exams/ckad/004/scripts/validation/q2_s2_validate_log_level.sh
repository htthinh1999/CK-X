#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get configmap app-config -n athena -o jsonpath='{.data.LOG_LEVEL}' 2>/dev/null)
if [ "$v" = "debug" ]; then echo "Success: LOG_LEVEL=debug"; exit 0; else echo "Error: LOG_LEVEL is '$v', expected debug"; exit 1; fi
