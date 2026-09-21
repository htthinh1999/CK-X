#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get job data-cleanup -n rhythm >/dev/null 2>&1; then
  echo "Success: job data-cleanup exists"; exit 0
fi
echo "Error: job data-cleanup not found in rhythm"; exit 1
