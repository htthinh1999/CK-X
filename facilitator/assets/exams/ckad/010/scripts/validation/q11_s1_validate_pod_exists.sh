#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod annotated-pod -n prosperity >/dev/null 2>&1; then
  echo "Success: Pod annotated-pod exists in prosperity"
  exit 0
else
  echo "Error: Pod annotated-pod not found in prosperity"
  exit 1
fi
