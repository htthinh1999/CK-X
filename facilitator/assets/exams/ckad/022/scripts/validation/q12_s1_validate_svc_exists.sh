#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get svc ascend-svc -n ascend >/dev/null 2>&1; then
  echo "Success: service ascend-svc exists in ascend"
  exit 0
fi
echo "Error: service ascend-svc not found in ascend"
exit 1
