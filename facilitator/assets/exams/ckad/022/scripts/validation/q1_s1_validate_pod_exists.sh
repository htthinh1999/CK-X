#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod musashi-pod -n apex >/dev/null 2>&1; then
  echo "Success: pod musashi-pod exists in apex"
  exit 0
fi
echo "Error: pod musashi-pod not found in apex"
exit 1
