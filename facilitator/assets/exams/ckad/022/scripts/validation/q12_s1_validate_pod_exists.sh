#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod secure-pod -n summit >/dev/null 2>&1; then
  echo "Success: pod secure-pod exists in summit"
  exit 0
fi
echo "Error: pod secure-pod not found in summit"
exit 1
