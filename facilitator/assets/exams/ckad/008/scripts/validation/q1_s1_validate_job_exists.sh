#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get job echo-job -n stone >/dev/null 2>&1; then
  echo "Success: job echo-job exists"; exit 0
else
  echo "Error: job echo-job not found"; exit 1
fi
