#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod tcp-health -n ember >/dev/null 2>&1; then
  echo "Success: pod exists"
  exit 0
else
  echo "Error: pod tcp-health not found in ember"
  exit 1
fi
