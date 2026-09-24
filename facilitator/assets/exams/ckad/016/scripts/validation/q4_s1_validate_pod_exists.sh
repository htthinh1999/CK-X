#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod thunder-logger -n thunder >/dev/null 2>&1; then
  echo "Success: pod thunder-logger exists"; exit 0
fi
echo "Error: pod thunder-logger not found in thunder"; exit 1
