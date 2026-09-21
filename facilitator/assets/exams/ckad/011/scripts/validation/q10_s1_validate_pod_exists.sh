#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod inspect-pod -n abyss >/dev/null 2>&1; then
  echo "Success: Pod inspect-pod exists in abyss"
  exit 0
else
  echo "Error: Pod inspect-pod not found in abyss"
  exit 1
fi
