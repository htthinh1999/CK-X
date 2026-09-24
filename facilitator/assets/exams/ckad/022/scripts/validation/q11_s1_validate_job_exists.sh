#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get job data-processor -n pinnacle >/dev/null 2>&1; then
  echo "Success: job data-processor exists in pinnacle"
  exit 0
fi
echo "Error: job data-processor not found in pinnacle"
exit 1
