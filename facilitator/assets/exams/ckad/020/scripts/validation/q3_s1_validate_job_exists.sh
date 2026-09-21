#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get job index-processor -n primal >/dev/null 2>&1; then
  echo "Success: job index-processor exists in primal"
  exit 0
fi
echo "Error: job index-processor not found in primal"
exit 1
