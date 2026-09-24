#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod logger -n lunar >/dev/null 2>&1; then
  echo "Success: pod logger exists in lunar"
  exit 0
else
  echo "Error: pod logger not found in lunar"
  exit 1
fi
