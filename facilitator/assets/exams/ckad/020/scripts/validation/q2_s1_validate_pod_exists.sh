#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod data-transformer -n origin >/dev/null 2>&1; then
  echo "Success: pod data-transformer exists in origin"
  exit 0
fi
echo "Error: pod data-transformer not found in origin"
exit 1
