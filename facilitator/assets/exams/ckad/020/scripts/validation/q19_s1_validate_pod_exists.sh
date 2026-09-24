#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod secure-pod -n ancient >/dev/null 2>&1; then
  echo "Success: pod secure-pod exists in ancient"
  exit 0
fi
echo "Error: pod secure-pod not found in ancient"
exit 1
