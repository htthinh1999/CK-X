#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get secret db-credentials -n coral >/dev/null 2>&1; then
  echo "Success: secret db-credentials exists in coral"; exit 0
fi
echo "Error: secret db-credentials not found in coral"; exit 1
