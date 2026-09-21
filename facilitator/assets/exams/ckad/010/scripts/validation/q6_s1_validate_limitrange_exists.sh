#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get limitrange pod-limits -n blessing >/dev/null 2>&1; then
  echo "Success: LimitRange pod-limits exists in blessing"
  exit 0
else
  echo "Error: LimitRange pod-limits not found in blessing"
  exit 1
fi
