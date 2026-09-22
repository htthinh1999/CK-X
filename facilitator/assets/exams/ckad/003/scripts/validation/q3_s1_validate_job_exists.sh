#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get job data-processor -n spark >/dev/null 2>&1; then
  echo "Success: job exists"
  exit 0
else
  echo "Error: job data-processor not found in spark"
  exit 1
fi
