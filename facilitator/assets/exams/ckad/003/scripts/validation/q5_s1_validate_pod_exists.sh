#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod crash-app -n ember >/dev/null 2>&1; then
  echo "Success: pod exists"
  exit 0
else
  echo "Error: pod crash-app not found in ember"
  exit 1
fi
