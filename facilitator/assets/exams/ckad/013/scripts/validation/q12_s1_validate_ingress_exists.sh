#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get ingress secure-ingress -n solstice >/dev/null 2>&1; then
  echo "Success: ingress secure-ingress exists"
  exit 0
else
  echo "Error: ingress secure-ingress not found"
  exit 1
fi
