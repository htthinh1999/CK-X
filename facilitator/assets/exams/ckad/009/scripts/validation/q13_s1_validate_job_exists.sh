#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get job deadline-job -n hollow >/dev/null 2>&1; then
  echo "Success: job deadline-job exists in hollow"; exit 0
else
  echo "Error: job deadline-job not found in hollow"; exit 1
fi
