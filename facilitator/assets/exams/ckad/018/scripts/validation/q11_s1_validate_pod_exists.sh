#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod health-check -n harmony >/dev/null 2>&1; then
  echo "Success: pod health-check exists"; exit 0
fi
echo "Error: pod health-check not found in harmony"; exit 1
