#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get job parallel-job -n canopy >/dev/null 2>&1; then
  echo "Success: job parallel-job exists in canopy"; exit 0
else
  echo "Error: job parallel-job not found in canopy"; exit 1
fi
