#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment terra-web -n terra >/dev/null 2>&1; then
  echo "Success: deployment terra-web exists in terra"
  exit 0
fi
echo "Error: deployment terra-web not found in terra"
exit 1
