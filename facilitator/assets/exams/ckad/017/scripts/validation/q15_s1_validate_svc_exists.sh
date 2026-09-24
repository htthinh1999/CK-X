#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get svc multi-port-svc -n depths >/dev/null 2>&1; then
  echo "Success: service multi-port-svc exists in depths"; exit 0
fi
echo "Error: service multi-port-svc not found in depths"; exit 1
