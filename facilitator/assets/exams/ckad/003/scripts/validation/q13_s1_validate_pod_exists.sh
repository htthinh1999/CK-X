#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod config-reader -n flame >/dev/null 2>&1; then
  echo "Success: pod exists"
  exit 0
else
  echo "Error: pod config-reader not found in flame"
  exit 1
fi
