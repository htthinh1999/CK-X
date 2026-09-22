#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod graceful-shutdown -n ancient >/dev/null 2>&1; then
  echo "Success: pod graceful-shutdown exists in ancient"
  exit 0
fi
echo "Error: pod graceful-shutdown not found in ancient"
exit 1
