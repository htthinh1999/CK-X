#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment backend-v2 -n spark >/dev/null 2>&1; then
  echo "Success: deployment backend-v2 exists"; exit 0
fi
echo "Error: deployment backend-v2 not found in spark"; exit 1
