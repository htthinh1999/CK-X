#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod web -n harvest >/dev/null 2>&1; then
  echo "Success: Pod web exists in harvest"
  exit 0
else
  echo "Error: Pod web not found in harvest"
  exit 1
fi
