#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get ingress api-ingress -n citadel >/dev/null 2>&1; then
  echo "Success: Ingress api-ingress exists in citadel"
  exit 0
else
  echo "Error: Ingress api-ingress exists in citadel - not found"
  exit 1
fi
