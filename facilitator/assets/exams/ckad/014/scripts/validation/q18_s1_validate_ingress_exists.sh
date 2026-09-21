#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get ingress star-ingress -n starlight >/dev/null 2>&1; then
  echo "Success: ingress star-ingress exists in starlight"
  exit 0
else
  echo "Error: ingress star-ingress not found in starlight"
  exit 1
fi
