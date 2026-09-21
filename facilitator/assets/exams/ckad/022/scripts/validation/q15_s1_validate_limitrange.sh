#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get limitrange cpu-limits -n crown >/dev/null 2>&1; then
  echo "Success: limitrange cpu-limits exists in crown"
  exit 0
fi
echo "Error: limitrange cpu-limits not found in crown"
exit 1
