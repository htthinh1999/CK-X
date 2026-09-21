#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
l=$(kubectl get cj data-sync -n coral -o jsonpath='{.spec.failedJobsHistoryLimit}' 2>/dev/null)
if [ "$l" = "5" ]; then
  echo "Success: failedJobsHistoryLimit is 5"; exit 0
fi
echo "Error: failedJobsHistoryLimit is '$l', expected 5"; exit 1
