#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pv glory-pv >/dev/null 2>&1; then
  echo "Success: pv glory-pv exists"
  exit 0
fi
echo "Error: pv glory-pv not found"
exit 1
