#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get networkpolicy allow-web -n legacy >/dev/null 2>&1; then
  echo "Success: networkpolicy allow-web exists in legacy"
  exit 0
fi
echo "Error: networkpolicy allow-web not found in legacy"
exit 1
