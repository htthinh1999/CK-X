#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service external-api -n hermes >/dev/null 2>&1; then echo "Success: service external-api exists"; exit 0; else echo "Error: service external-api not found in hermes"; exit 1; fi
