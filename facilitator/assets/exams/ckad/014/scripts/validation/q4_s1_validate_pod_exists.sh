#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod legacy-app -n eclipse >/dev/null 2>&1; then
  echo "Success: pod legacy-app exists in eclipse"
  exit 0
else
  echo "Error: pod legacy-app not found in eclipse"
  exit 1
fi
