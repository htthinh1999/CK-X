#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment prod-web-app -n zenith >/dev/null 2>&1; then
  echo "Success: deployment prod-web-app exists"
  exit 0
else
  echo "Error: deployment prod-web-app not found"
  exit 1
fi
