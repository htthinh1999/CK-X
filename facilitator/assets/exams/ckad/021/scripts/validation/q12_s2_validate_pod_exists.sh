#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod config-pod -n aegis >/dev/null 2>&1; then
  echo "Success: pod config-pod exists in aegis"
  exit 0
fi
echo "Error: pod config-pod missing in aegis"
exit 1
