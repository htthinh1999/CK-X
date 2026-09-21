#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get ingress cosmos-ingress -n cosmos >/dev/null 2>&1; then
  echo "Success: ingress cosmos-ingress exists in cosmos"
  exit 0
fi
echo "Error: ingress cosmos-ingress not found in cosmos"
exit 1
