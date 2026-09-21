#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get job batch-processor -n bulwark >/dev/null 2>&1; then
  echo "Success: Job batch-processor exists in bulwark"
  exit 0
else
  echo "Error: Job batch-processor exists in bulwark - not found"
  exit 1
fi
