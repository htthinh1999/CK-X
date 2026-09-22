#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get secret app-secret -n anchor >/dev/null 2>&1; then
  echo "Success: secret app-secret exists in anchor"
  exit 0
fi
echo "Error: secret app-secret missing in anchor"
exit 1
