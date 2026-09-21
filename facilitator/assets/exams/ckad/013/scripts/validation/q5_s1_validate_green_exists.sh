#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment app-green -n flare >/dev/null 2>&1; then
  echo "Success: deployment app-green exists"
  exit 0
else
  echo "Error: deployment app-green not found"
  exit 1
fi
