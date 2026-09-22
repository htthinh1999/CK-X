#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get ingress rewrite-ingress -n ocean >/dev/null 2>&1; then
  echo "Success: ingress rewrite-ingress exists in ocean"; exit 0
fi
echo "Error: ingress rewrite-ingress not found in ocean"; exit 1
