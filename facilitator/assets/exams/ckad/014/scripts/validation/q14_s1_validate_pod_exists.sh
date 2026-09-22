#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod secure-pod -n eclipse >/dev/null 2>&1; then
  echo "Success: pod secure-pod exists in eclipse"
  exit 0
else
  echo "Error: pod secure-pod not found in eclipse"
  exit 1
fi
