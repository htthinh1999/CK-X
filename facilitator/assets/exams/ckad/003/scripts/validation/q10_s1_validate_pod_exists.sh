#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod data-transform -n phoenix >/dev/null 2>&1; then
  echo "Success: pod exists"
  exit 0
else
  echo "Error: pod data-transform not found in phoenix"
  exit 1
fi
