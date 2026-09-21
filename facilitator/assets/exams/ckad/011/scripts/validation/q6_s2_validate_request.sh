#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
req=$(kubectl get pvc sea-pvc -n depths -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null)
if [ "$req" = "2Gi" ]; then
  echo "Success: storage request is 2Gi"
  exit 0
else
  echo "Error: storage request is '$req', expected 2Gi"
  exit 1
fi
