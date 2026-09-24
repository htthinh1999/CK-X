#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod logging-pod -n aegis >/dev/null 2>&1; then
  echo "Success: pod logging-pod exists in aegis"
  exit 0
fi
echo "Error: pod logging-pod missing in aegis"
exit 1
