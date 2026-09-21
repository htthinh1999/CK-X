#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
s=$(kubectl get pvc app-data-pvc -n aurora -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null)
if [ "$s" = "500Mi" ]; then
  echo "Success: storage request 500Mi"
  exit 0
else
  echo "Error: storage is '$s' (expected 500Mi)"
  exit 1
fi
