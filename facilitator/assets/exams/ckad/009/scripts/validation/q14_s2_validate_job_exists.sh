#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get job manual-job -n thicket >/dev/null 2>&1; then
  echo "Success: job manual-job exists in thicket"; exit 0
else
  echo "Error: job manual-job not found in thicket"; exit 1
fi
